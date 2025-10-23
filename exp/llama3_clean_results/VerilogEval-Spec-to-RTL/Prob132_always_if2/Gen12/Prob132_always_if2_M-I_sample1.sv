// Top-level module with simplified logic
module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Directly assign shut_off_computer based on cpu_overheated
    assign shut_off_computer = cpu_overheated ? 1 : 0;
    
    // Assign keep_driving based on arrived and gas_tank_empty
    assign keep_driving = !arrived && !gas_tank_empty ? 1 : 0;

endmodule