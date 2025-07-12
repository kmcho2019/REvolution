module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

// Ringer activates when ringing and NOT in vibrate mode
assign ringer = ring & ~vibrate_mode;

// Motor activates when ringing and in vibrate mode
assign motor = ring & vibrate_mode;

endmodule