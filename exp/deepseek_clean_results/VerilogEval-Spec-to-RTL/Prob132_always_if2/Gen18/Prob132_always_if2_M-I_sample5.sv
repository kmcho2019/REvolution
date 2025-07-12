module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Direct connection - CPU overheat triggers immediate shutdown
    assign shut_off_computer = cpu_overheated;

    // Driving logic: 
    // keep_driving = (not arrived) AND (tank has gas)
    // Implemented as NAND followed by inverter for better area in some libraries
    wire not_arrived = ~arrived;
    wire tank_has_gas = ~gas_tank_empty;
    assign keep_driving = ~(not_arrived & tank_has_gas);

endmodule