module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// If there is an incoming call (ring=1),
// output ringer if not in vibrate mode,
// output motor if in vibrate mode.
// Only one output is active at a time.
// If no incoming call, both outputs are off.

assign ringer = ring & ~vibrate_mode;
assign motor  = ring & vibrate_mode;

endmodule