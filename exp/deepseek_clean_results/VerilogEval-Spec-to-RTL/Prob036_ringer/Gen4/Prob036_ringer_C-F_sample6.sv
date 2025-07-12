module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Outputs are mutually exclusive by design
    assign ringer = (ring & ~vibrate_mode);
    assign motor  = (ring & vibrate_mode);
endmodule