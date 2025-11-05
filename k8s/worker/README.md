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

### 🧠 4. Initialize the Worker node

On control plane node, run:

sudo kubeadm token create --print-join-command

run on the worker, for example:

kubeadm join 10.10.0.5:6443 --token abcd12.xxxxxx --discovery-token-ca-cert-hash sha256:xxxxxxxxxxxxxxxxxxxx

Check on controlplane:

kubectl get nodes