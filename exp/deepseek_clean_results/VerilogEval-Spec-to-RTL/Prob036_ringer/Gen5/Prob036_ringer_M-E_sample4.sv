module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    wire normal_mode = ~vibrate_mode;
    wire ring_enabled = ring;
    
    assign ringer = ring_enabled & normal_mode;
    assign motor  = ring_enabled & vibrate_mode;

endmodule