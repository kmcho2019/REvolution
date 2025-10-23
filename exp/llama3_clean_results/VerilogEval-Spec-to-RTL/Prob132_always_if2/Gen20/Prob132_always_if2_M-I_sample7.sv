// Module to determine if the computer should shut off based on overheating
module ShutOffComputer(
    input      cpu_overheated,
    output     shut_off_computer
);
    // Directly assign shut_off_computer based on cpu_overheated
    assign shut_off_computer = cpu_overheated? 1 : 0;
endmodule

// Module to determine if the car should keep driving
module KeepDriving(
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);
    // Keep driving if not arrived and the gas tank is not empty
    assign keep_driving = ~arrived && ~gas_tank_empty? 1 : 0;
endmodule

// Top-level module
module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);
    // Instantiate ShutOffComputer and KeepDriving modules
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