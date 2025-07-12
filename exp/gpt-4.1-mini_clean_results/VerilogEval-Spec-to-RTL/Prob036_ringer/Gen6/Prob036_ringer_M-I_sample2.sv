module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// When ring is active:
//   - If vibrate_mode=1, motor is on
//   - Else ringer is on
assign ringer = ring & ~vibrate_mode;
assign motor  = ring &  vibrate_mode;

endmodule