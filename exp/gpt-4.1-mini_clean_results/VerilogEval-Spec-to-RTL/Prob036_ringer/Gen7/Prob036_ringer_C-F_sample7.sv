module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// Control logic for cellphone ringer and vibration motor:
// - When 'ring' is asserted:
//     - If 'vibrate_mode' = 1, activate the vibration motor only (motor = 1, ringer = 0).
//     - If 'vibrate_mode' = 0, activate the ringer only (ringer = 1, motor = 0).
// - When 'ring' = 0, both outputs are off (0).
//
// This ensures mutual exclusivity and clear prioritization of vibrate mode.

assign ringer = ring & ~vibrate_mode; // Ringer active when ringing and NOT in vibrate mode
assign motor  = ring &  vibrate_mode; // Motor active when ringing and in vibrate mode

endmodule