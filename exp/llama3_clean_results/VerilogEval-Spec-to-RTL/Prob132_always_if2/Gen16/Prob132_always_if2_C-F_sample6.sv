module ShutOffComputer(
    input      cpu_overheated,
    output     shut_off_computer
);
    // Assign shut_off_computer directly based on cpu_overheated
    assign shut_off_computer = cpu_overheated;
endmodule

module KeepDriving(
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);
    // Assign keep_driving based on the condition that arrived is false and gas_tank_empty is false
    assign keep_driving = ~arrived && ~gas_tank_empty;
endmodule

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