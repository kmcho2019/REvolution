module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Explicit priority: when ring is active, choose output based on vibrate_mode
    assign ringer = ring ? ~vibrate_mode : 1'b0;
    assign motor  = ring ? vibrate_mode : 1'b0;

endmodule