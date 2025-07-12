module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Priority-based enable signals
    wire motor_enable = ring & vibrate_mode;
    wire ringer_enable = ring & ~motor_enable;  // Ringer only if motor isn't enabled
    
    assign ringer = ringer_enable;
    assign motor = motor_enable;
endmodule