// Define a module for ShutOffComputer
module ShutOffComputer #(
    parameter CPU_OVH_WIDTH = 1
) (
    input      [CPU_OVH_WIDTH-1:0] cpu_overheated,
    output     [CPU_OVH_WIDTH-1:0] shut_off_computer
);
    // Directly assign shut_off_computer based on cpu_overheated
    assign shut_off_computer = cpu_overheated;
endmodule

// Define a module for KeepDriving
module KeepDriving #(
    parameter ARRIVED_WIDTH = 1,
    parameter GAS_TANK_EMPTY_WIDTH = 1
) (
    input      [ARRIVED_WIDTH-1:0] arrived,
    input      [GAS_TANK_EMPTY_WIDTH-1:0] gas_tank_empty,
    output     [ARRIVED_WIDTH-1:0] keep_driving
);
    // Use a more explicit approach to handle the keep_driving logic
    assign keep_driving = (!arrived) && (!gas_tank_empty);
endmodule

// Define the TopModule
module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);
    // Instantiate the ShutOffComputer and KeepDriving modules
    ShutOffComputer #(
       .CPU_OVH_WIDTH(1)
    ) soc (
      .cpu_overheated(cpu_overheated),
      .shut_off_computer(shut_off_computer)
    );

    KeepDriving #(
       .ARRIVED_WIDTH(1),
       .GAS_TANK_EMPTY_WIDTH(1)
    ) kd (
      .arrived(arrived),
      .gas_tank_empty(gas_tank_empty),
      .keep_driving(keep_driving)
    );
endmodule