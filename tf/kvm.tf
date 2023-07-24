# Get a Floating IP to use
resource "openstack_networking_floatingip_v2" "fip_1" {
    pool       = "public"
}

# Define a security group for our instance
resource "openstack_networking_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "My neutron security group"
}

# add a rule to allow ssh
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

# Create the instance, referencing the security group
resource "openstack_compute_instance_v2" "test_instance" {
    name = "test_instance"
    image_name = "CC-Ubuntu20.04"
    flavor_name = "m1.small"
    key_pair = "msherman-laptop"
    network {
      name = "sharednet1"
    }
    security_groups = [openstack_networking_secgroup_v2.secgroup_1.id]
}

# attach the floating IP to our instance
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
    floating_ip = openstack_networking_floatingip_v2.fip_1.address
    instance_id = openstack_compute_instance_v2.test_instance.id
}

# print out what IP to SSH to
output "instance_public_ip" {
  value = openstack_networking_floatingip_v2.fip_1.address
}



