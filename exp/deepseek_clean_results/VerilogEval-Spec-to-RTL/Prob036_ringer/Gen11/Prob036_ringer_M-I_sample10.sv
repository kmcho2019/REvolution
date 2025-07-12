module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Explicit handling of ring=0 case first
    assign ringer = ring ? ~vibrate_mode : 1'b0;
    assign motor  = ring ?  vibrate_mode : 1'b0;

endmodule