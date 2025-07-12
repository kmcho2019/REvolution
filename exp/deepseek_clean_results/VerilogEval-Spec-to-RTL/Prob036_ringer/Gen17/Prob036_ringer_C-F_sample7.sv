module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Clear state definitions
    wire normal_ring_mode = ring & ~vibrate_mode;
    wire vibrate_ring_mode = ring & vibrate_mode;

    // Output assignments with explicit conditions
    assign ringer = normal_ring_mode;
    assign motor  = vibrate_ring_mode;

endmodule