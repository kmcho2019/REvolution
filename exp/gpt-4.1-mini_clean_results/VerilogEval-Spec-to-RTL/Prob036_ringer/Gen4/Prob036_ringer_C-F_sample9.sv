module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// When there is an incoming call (ring = 1):
// - If vibrate_mode is active (1), turn on the motor only.
// - Otherwise (vibrate_mode = 0), turn on the ringer only.
// Ensures mutual exclusivity: ringer and motor are never on simultaneously.
// When there is no incoming call (ring = 0), both outputs are off.

assign ringer = ring & ~vibrate_mode; // Ringer on when ringing and NOT in vibrate mode
assign motor  = ring &  vibrate_mode;  // Motor on when ringing and in vibrate mode

endmodule