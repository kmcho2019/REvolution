module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    // One-hot encoding for outputs: [motor, ringer]
    wire motor_sel;
    wire ringer_sel;

    // Combinational FSM logic for output selection
    assign motor_sel  = ring & vibrate_mode;
    assign ringer_sel = ring & ~vibrate_mode;

    // Assign outputs from FSM signals (mutually exclusive)
    assign motor  = motor_sel;
    assign ringer = ringer_sel;

endmodule