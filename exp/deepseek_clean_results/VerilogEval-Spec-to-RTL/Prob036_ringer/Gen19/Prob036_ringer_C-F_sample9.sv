module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Clear mutually exclusive assignments
    assign ringer = ring ? ~vibrate_mode : 1'b0;
    assign motor  = ring ?  vibrate_mode : 1'b0;

endmodule