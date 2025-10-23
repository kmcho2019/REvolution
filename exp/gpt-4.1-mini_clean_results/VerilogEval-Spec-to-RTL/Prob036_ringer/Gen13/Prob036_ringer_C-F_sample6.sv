module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// Activate motor if ringing and vibrate mode enabled
assign motor  = ring & vibrate_mode;

// Activate ringer if ringing and vibrate mode disabled
assign ringer = ring & ~vibrate_mode;

endmodule