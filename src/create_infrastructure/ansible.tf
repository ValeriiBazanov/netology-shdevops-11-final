resource "local_file" "inventory_cfg" {
    content = templatefile("${path.module}/host.tftpl",
    { 
        master_a = module.master_nodes.final-work-subnet-a.vm
        master_b = module.master_nodes.final-work-subnet-b.vm
        master_d = module.master_nodes.final-work-subnet-d.vm
        worker_a = module.worker_nodes.final-work-subnet-a.vm
        worker_b = module.worker_nodes.final-work-subnet-b.vm
        worker_d = module.worker_nodes.final-work-subnet-d.vm
        ip_nat = module.nat_vm.vm.0.network_interface.0.nat_ip_address
        master_init_name = module.master_nodes.final-work-subnet-a.vm.0.name

    }  )

    filename = "../tmp/host.yml"
}