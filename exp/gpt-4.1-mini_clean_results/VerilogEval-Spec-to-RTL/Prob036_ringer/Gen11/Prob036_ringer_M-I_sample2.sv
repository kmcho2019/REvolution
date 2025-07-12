module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    // Gate with ring once to reduce switching on vibrate_mode when not ringing
    wire ring_active = ring;

    assign motor  = ring_active & vibrate_mode;
    assign ringer = ring_active & ~vibrate_mode;

endmodule