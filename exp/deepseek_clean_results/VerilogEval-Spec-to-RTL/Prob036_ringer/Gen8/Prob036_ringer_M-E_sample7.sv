module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Mux-based implementation
    assign ringer = vibrate_mode ? 1'b0 : ring;
    assign motor  = vibrate_mode ? ring : 1'b0;
endmodule