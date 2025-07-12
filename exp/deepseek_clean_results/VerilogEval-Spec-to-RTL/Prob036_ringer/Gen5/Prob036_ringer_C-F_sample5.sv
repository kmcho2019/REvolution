module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Ringer and motor are mutually exclusive outputs:
    // - Ringer activates when ring=1 and not in vibrate mode
    // - Motor activates when ring=1 and in vibrate mode
    assign ringer = (ring & ~vibrate_mode);
    assign motor  = (ring & vibrate_mode);
endmodule