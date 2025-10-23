module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Mux implementation where:
    // - vibrate_mode selects between ringer (0) and motor (1)
    // - ring acts as the enable for the mux
    assign ringer = ring & (vibrate_mode == 0);
    assign motor  = ring & (vibrate_mode == 1);
endmodule