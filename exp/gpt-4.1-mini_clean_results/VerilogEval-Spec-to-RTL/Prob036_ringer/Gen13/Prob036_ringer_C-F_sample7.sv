module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    // One-hot encoded internal signals for output selection
    wire motor_sel = ring & vibrate_mode;
    wire ringer_sel = ring & ~vibrate_mode;

    // Outputs driven exclusively based on ring and vibrate_mode
    assign motor  = motor_sel;  
    assign ringer = ringer_sel;

endmodule