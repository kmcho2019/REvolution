module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Directly assign the value of cpu_overheated to shut_off_computer
    assign shut_off_computer = cpu_overheated;
    
    // Use a conditional expression to assign the correct value to keep_driving
    // based on the arrived and gas_tank_empty signals
    assign keep_driving =!arrived &&!gas_tank_empty;

endmodule