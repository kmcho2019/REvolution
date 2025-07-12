read_libraries
read_verilog $synth_verilog
link_design $top_module

#if {[catch {link_design $top_module} result]} {
#    puts "Error: $result"
#    exit 1
#}

read_sdc $sdc_file

set startTime [clock milliseconds]
initialize_floorplan -site $site \
    -utilization $core_utilization \
    -aspect_ratio $aspect_ratio \
    -core_space $core_margin

source $tracks_file

puts "Default units for flow"
report_units
report_units_metric
source ${util_dir}/report_metrics.tcl
report_metrics "floorplan final" false false

exit


