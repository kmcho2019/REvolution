module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Use vibrate_mode as mux selector
    // When ring=0, both outputs are 0 regardless of selector
    assign ringer = ring ? (~vibrate_mode) : 1'b0;
    assign motor = ring ? vibrate_mode : 1'b0;

endmodule