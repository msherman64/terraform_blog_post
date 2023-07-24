### TACC #################
# Get a Floating IP to use
resource "openstack_networking_floatingip_v2" "fip_1" {
  provider = openstack.tacc
  pool       = "public"
}

# Create the instance, referencing the baremetal flavor, and scheduler hint
resource "openstack_compute_instance_v2" "test_instance" {
    provider = openstack.tacc
    name = "test_instance"
    image_name = "CC-Ubuntu20.04"
    flavor_name = "baremetal"
    key_pair = "mike-laptop"
    network {
      name = "sharednet1"
  }
  scheduler_hints {
    additional_properties = {
    "reservation" = "90d25f80-f25f-44b5-8168-d0767c5c0bba"
    }
  }
}

# attach the floating IP to our instance
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  provider = openstack.tacc
  floating_ip = openstack_networking_floatingip_v2.fip_1.address
  instance_id = openstack_compute_instance_v2.test_instance.id
}



### UC #################
# Get a Floating IP to use
resource "openstack_networking_floatingip_v2" "fip_1_uc" {
  provider = openstack.uc
  pool       = "public"
}

# Create the instance, referencing the baremetal flavor, and scheduler hint
resource "openstack_compute_instance_v2" "test_instance_uc" {
    provider = openstack.uc
    name = "test_instance"
    image_name = "CC-Ubuntu20.04"
    flavor_name = "baremetal"
    key_pair = "msherman-laptop"
    network {
      name = "sharednet1"
  }
  scheduler_hints {
    additional_properties = {
    "reservation" = "4b4d2a2f-4fbb-4c81-b3e2-c8091e50d3fe"
    }
  }
}

# attach the floating IP to our instance
resource "openstack_compute_floatingip_associate_v2" "fip_1_uc" {
  provider = openstack.uc
  floating_ip = openstack_networking_floatingip_v2.fip_1_uc.address
  instance_id = openstack_compute_instance_v2.test_instance_uc.id
}

# print out what IP to SSH to
output "instance_public_ip_tacc" {
  value = openstack_networking_floatingip_v2.fip_1.address
}
output "instance_public_ip_uc" {
  value = openstack_networking_floatingip_v2.fip_1_uc.address
}
