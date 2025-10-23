// Define a module for ShutOffComputer
module ShutOffComputer(
    input      cpu_overheated,
    output     shut_off_computer
);
    // Directly assign shut_off_computer based on cpu_overheated
    assign shut_off_computer = cpu_overheated;
endmodule

// Define a module for KeepDriving
module KeepDriving(
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);
    // Use a more explicit approach to handle the keep_driving logic
    assign keep_driving = ~(arrived || gas_tank_empty);
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
    ShutOffComputer soc(
      .cpu_overheated(cpu_overheated),
      .shut_off_computer(shut_off_computer)
    );

    KeepDriving kd(
      .arrived(arrived),
      .gas_tank_empty(gas_tank_empty),
      .keep_driving(keep_driving)
    );
endmodule