module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire ringing_active = ring;

// If vibrate_mode is 1 and ringing is active, motor = 1, else 0.
// If vibrate_mode is 0 and ringing is active, ringer = 1, else 0.
assign motor  = vibrate_mode ? ringing_active : 1'b0;
assign ringer = vibrate_mode ? 1'b0          : ringing_active;

endmodule