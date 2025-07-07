set util_dir /project/cad-team/LX_Semicon/kmcho/EoR/script/util
set pdk_dir /project/cad-team/LX_Semicon/kmcho/EoR/pdk
set design TopModule
set top_module TopModule
set synth_verilog /project/cad-team/LX_Semicon/kmcho/EoR/exp/gpt-4.1-mini/VerilogEval-Spec-to-RTL/Prob064_vector3/Gen0/TopModule.syn.v
set sdc_file /project/cad-team/LX_Semicon/kmcho/EoR/exp/gpt-4.1-mini/VerilogEval-Spec-to-RTL/Prob064_vector3/Gen0/TopModule.sdc
set core_utilization 0.5
set aspect_ratio 1.0
set max metal10
set min metal2

source "$util_dir/helpers.tcl"
source "$util_dir/flow_helpers.tcl"
source "$pdk_dir/Nangate45/Nangate45.vars"

set core_margin 0.0
set global_place_density 0.99

set platform "nangate45"
set tech_lef "$pdk_dir/Nangate45/Nangate45_tech.lef"
set std_cell_lef "$pdk_dir/Nangate45/Nangate45_stdcell.lef"
set extra_lef {}
set liberty_file "$pdk_dir/Nangate45/Nangate45_typ.lib"
set extra_liberty {}
set site "FreePDK45_38x28_10R_NP_162NW_34O"
set pdn_cfg "$pdk_dir/Nangate45/Nangate45.pdn.tcl"
set tracks_file "$pdk_dir/Nangate45/Nangate45.tracks"
set io_placer_hor_layer metal3
set io_placer_ver_layer metal2

set tapcell_args "-distance 120 \
              -tapcell_master TAPCELL_X1 \
              -endcap_master TAPCELL_X1"


## default value
set global_place_density_penalty 8e-5
# placement padding in SITE widths applied to both sides
set global_place_pad 2
set detail_place_pad 1

# global route
set global_routing_layers metal2-metal10
#set global_routing_clock_layers metal6-metal10
set global_routing_layer_adjustments {{{metal2-metal10} 0.5}}

#source -echo "$util_dir/flow.tcl"

if {[catch {source "$util_dir/flow.tcl"} result]} {
    puts "Error: $result"
    exit 1
}

exit
