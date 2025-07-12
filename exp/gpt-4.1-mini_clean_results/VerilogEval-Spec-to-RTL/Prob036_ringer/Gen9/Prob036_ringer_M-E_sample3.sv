module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

// ringer is on if ring is asserted and not in vibrate mode
assign ringer = ring & ~vibrate_mode;

// motor is on if ring is asserted and vibrate mode is enabled
assign motor = ring & vibrate_mode;

endmodule