module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Internal enable signals
    wire ringer_enable = ~vibrate_mode;
    wire motor_enable = vibrate_mode;
    
    // Gated outputs - only active when ring is high
    assign ringer = ring & ringer_enable;
    assign motor = ring & motor_enable;
endmodule