module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Parameter to control shutdown behavior (1 = immediate, 0 = delayed)
    parameter IMMEDIATE_SHUTDOWN = 1;
    
    // Continuous assignment for computer shutdown
    assign shut_off_computer = IMMEDIATE_SHUTDOWN ? cpu_overheated : 1'b0;
    
    // Derived signal for driving logic
    wire should_keep_driving = ~arrived & ~gas_tank_empty;
    
    // Continuous assignment for driving decision
    assign keep_driving = should_keep_driving;

endmodule