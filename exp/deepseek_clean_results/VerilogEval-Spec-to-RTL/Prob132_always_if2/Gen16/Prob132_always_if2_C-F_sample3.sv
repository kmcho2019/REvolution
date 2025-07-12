module TopModule (
    // Input signals
    input      cpu_overheated,    // High when CPU temperature critical
    input      arrived,           // High when destination reached
    input      gas_tank_empty,    // High when no fuel remaining
    
    // Output signals
    output     shut_off_computer, // Emergency shutdown signal
    output     keep_driving       // Vehicle control signal
);

    // Combined continuous assignment for both outputs:
    // - Computer shuts off immediately when overheated
    // - Vehicle keeps driving only when not arrived AND has fuel
    assign {shut_off_computer, keep_driving} = {cpu_overheated, ~arrived & ~gas_tank_empty};

endmodule