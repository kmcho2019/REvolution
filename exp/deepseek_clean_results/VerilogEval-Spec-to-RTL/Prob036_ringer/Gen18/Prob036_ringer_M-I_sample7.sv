module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    assign ringer = ~(~ring | vibrate_mode);  // NOR implementation
    assign motor  = ring & vibrate_mode;      // Same as original
endmodule