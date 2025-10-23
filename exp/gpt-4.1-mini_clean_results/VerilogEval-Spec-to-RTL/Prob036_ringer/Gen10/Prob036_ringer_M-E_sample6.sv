module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// When ring is 0, both outputs are 0.
// When ring is 1:
// - If vibrate_mode is 0: ringer = 1, motor = 0
// - If vibrate_mode is 1: ringer = 0, motor = 1

assign {ringer, motor} = ring ? {~vibrate_mode, vibrate_mode} : 2'b00;

endmodule