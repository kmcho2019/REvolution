module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Use vibrate_mode as select for a 2:1 MUX
    assign ringer = ring & (vibrate_mode == 0);
    assign motor  = ring & (vibrate_mode == 1);
endmodule