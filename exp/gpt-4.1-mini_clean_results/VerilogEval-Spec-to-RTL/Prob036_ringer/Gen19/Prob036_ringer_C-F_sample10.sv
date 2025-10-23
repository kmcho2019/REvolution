module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// Internal one-hot signals selected by vibrate_mode
wire ringer_sel = ~vibrate_mode;
wire motor_sel  = vibrate_mode;

// Use ring as enable for output, and select one output exclusively via mux logic
assign ringer = ring & ringer_sel;
assign motor  = ring & motor_sel;

endmodule