module ShutOffComputer(
    input      cpu_overheated,
    output reg shut_off_computer
);

    always @(*) begin
        shut_off_computer = cpu_overheated;
    end

endmodule

module KeepDriving(
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        keep_driving = !arrived && !gas_tank_empty;
    end

endmodule

module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

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