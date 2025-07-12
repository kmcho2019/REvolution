module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Direct continuous assignments showing clear relationship
    assign ringer = ring & ~vibrate_mode;  // Active when ringing and not in vibrate mode
    assign motor  = ring &  vibrate_mode;  // Active when ringing and in vibrate mode

endmodule