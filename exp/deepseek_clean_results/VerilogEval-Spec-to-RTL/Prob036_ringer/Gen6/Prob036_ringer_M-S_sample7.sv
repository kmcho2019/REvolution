module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Activate ringer or motor exclusively based on vibrate_mode
    assign ringer = ring & ~vibrate_mode;
    assign motor  = ring & vibrate_mode;
endmodule