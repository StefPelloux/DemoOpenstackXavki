# Define required providers
terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
}


resource "openstack_compute_keypair_v2" "keypair_xavki" {
  name = "keypair_xavki"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7As6+dFadbrGidzTjcBn8XBwgqAPGpkM/YfjYlpOcHI/BUXIRyqyMdiMv0w7M0XC2O9MFroA3LabqUr7sR9ZOqgOixNBRVAWqBYNjufG1nFsoS365WNE26FawXAKkJMZkHWN1FS4PSt9k68n7b706W9HSIuXN419gOi1zxAsCYy1MO0i8xIN8EpZCMdvHn/iAPazP5bCGWz5EHx87MESXB+nuasXTVbI2QQvSRwQBV4pkaJZvttw28mgB9VfaW+FkAIHVLQsHEVME02K/VkvlGWoJltcAEv00eBVge/2QIWM/eYOvDbZSNif0UXFRgtrB1hzotpKiefmumukKXfVsHFP/VBKVGDtCM5Gb8VoCapyK3kc9RzYgBRq9nQDaHd7aV47ynZVSqv35BsyZQSkgXGer2o49nrxoNPs1V/i8F40Op6ArEJS02GzRVDKtP5hLLYAdoueMD8r3kcYhey/QRazM0t2Vdu7YrjyjixjXsDmtUd6hsgRPVP7rsNJkjFs= stef@DESKTOP-4RPP4AI"
}


# Create a web security group
resource "openstack_compute_secgroup_v2" "web_server" {
  name        = "web_server"
  description = "Security Group Description"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}


# Create a web server
resource "openstack_compute_instance_v2" "web-server" {
  name            = "web-server"
  image_id        = "72a3f273-d2c4-4bd3-8002-fa910e6ed7df"
  flavor_name     = "a1-ram2-disk80-perf1"
  key_pair        = "keypair_xavki"
  security_groups = ["web_server"]

  metadata = {
    application = "web-app"
  }

  network {
    name = "ext-net1"
  }
}
