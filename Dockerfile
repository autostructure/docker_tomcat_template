FROM autostructure/puppet_ubuntu

RUN /opt/puppetlabs/bin/puppet module install autostructure-docker_laravel_module

COPY manifests /manifests

COPY hiera.yaml /hiera.yaml
COPY hieradata /hieradata

RUN apt-get update && \
    FACTER_hostname=some_image /opt/puppetlabs/bin/puppet apply manifests/init.pp --hiera_config=/hiera.yaml --detailed-exitcodes --verbose --show_diff --summarize  --app_management ; \
    rc=$?; if [ $rc -ne 0 ] && [ $rc -ne 2 ]; then exit 1; fi && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80
CMD ["/root/cmd_wrapper.sh"]
