module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire select_ringer;
wire select_motor;

// When ring is active, select which output to enable based on vibrate_mode
assign select_motor  = ring & vibrate_mode;
assign select_ringer = ring & ~vibrate_mode;

// Outputs are directly assigned from select signals, ensuring mutual exclusivity
assign ringer = select_ringer;
assign motor  = select_motor;

endmodule