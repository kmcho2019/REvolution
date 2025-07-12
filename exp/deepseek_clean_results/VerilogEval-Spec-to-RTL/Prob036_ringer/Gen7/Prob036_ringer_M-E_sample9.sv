module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // MUX-based implementation
    assign ringer = (vibrate_mode == 0) ? ring : 0;
    assign motor  = (vibrate_mode == 1) ? ring : 0;
endmodule