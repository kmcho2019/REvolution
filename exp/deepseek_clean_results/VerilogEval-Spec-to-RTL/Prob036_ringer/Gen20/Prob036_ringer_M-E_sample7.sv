module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Intermediate signals
    wire ring_active = ring;
    wire use_vibrate = ring_active & vibrate_mode;
    wire use_ringer = ring_active & ~vibrate_mode;

    // Output drivers
    assign ringer = use_ringer;
    assign motor = use_vibrate;
endmodule