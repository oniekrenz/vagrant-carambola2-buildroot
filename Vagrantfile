require 'facter'

config=YAML.load_file("config.yaml")
box=config['box']
memory=config['memory']
cpus=config['cpus']
cpucount=Facter.processorcount.to_i
puppet_dir='puppet'

case cpus
when "all"
  cpus=cpucount
when "half"
  cpus=cpucount / 2
else
  cpus=cpus.to_i
end
cpus=[[cpus.to_i, cpucount].min, 1].max


Vagrant.configure("2") do |config|
  config.vm.box = box

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", memory]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--cpus", cpus]
  end

  config.librarian_puppet.puppetfile_dir = puppet_dir + "/."

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = puppet_dir + "/manifests"
    puppet.manifest_file  = "default.pp"
    puppet.module_path = [puppet_dir + "/modules", puppet_dir + "/modules_local"]
    puppet.options = "--verbose --debug"
  end
end
