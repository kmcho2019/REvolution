module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Mode parameters for readability
    localparam NORMAL_MODE = 1'b0;
    localparam VIBRATE_MODE = 1'b1;

    // Output control logic
    assign ringer = (ring && (vibrate_mode == NORMAL_MODE));
    assign motor  = (ring && (vibrate_mode == VIBRATE_MODE));

endmodule