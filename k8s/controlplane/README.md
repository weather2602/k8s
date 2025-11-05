### ⚙️ 1. Prepare the System

On the control plane node only, SSH in and run:

sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl gpg


Disable swap (Kubernetes won’t start with swap on):

sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab


Load kernel modules needed by kube-proxy and container networking:

sudo modprobe overlay
sudo modprobe br_netfilter


Set up sysctl params (Kubernetes networking depends on these):

sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

### 🐳 2. Install Container Runtime (Containerd recommended)

You can use Docker, but Containerd is the modern default.

sudo apt install -y containerd


Generate a default config and enable Systemd cgroup driver (K8s expects this):

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

### 📦 3. Install Kubeadm, Kubelet, Kubectl

Add Google’s apt repo and keys:

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list


Then install:

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

### 🧠 4. Initialize the Control Plane

Pick a pod network CIDR — usually 10.244.0.0/16 for Flannel or 192.168.0.0/16 for Calico.

Run:

sudo kubeadm init --pod-network-cidr=10.244.0.0/16


This:

Generates and signs certificates,

Sets up the control plane components (API server, etcd, controller, scheduler),

Prints a kubeadm join command for the worker node — copy it.

If you see errors about swap or conntrack, fix them before retrying.

### 📋 5. Configure kubectl for Your User

After kubeadm completes successfully:

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


Now you can check:

kubectl get nodes
kubectl get pods -A


You’ll see the control plane in NotReady until you install a CNI plugin.

### 🌐 6. Install a CNI (Networking)

Example: Flannel

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml


After ~30 seconds:

kubectl get nodes