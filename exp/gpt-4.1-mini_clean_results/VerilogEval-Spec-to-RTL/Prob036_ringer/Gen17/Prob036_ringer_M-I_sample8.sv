module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// When ring is asserted, select output based on vibrate_mode:
// If vibrate_mode = 0, ringer = 1 and motor = 0;
// If vibrate_mode = 1, motor = 1 and ringer = 0;
// If ring = 0, both outputs = 0.
assign ringer = ring & ~vibrate_mode;
assign motor  = ring & vibrate_mode;

endmodule