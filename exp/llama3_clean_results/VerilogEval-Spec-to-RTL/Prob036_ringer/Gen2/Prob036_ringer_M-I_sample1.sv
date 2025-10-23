module TopModule(
    input  ring,
    input  vibrate_mode,
    output ringer,
    output motor
);

    // Using a single OR gate to reduce area consumption
    assign motor  = ring && vibrate_mode;
    assign ringer = ring && ~vibrate_mode;

endmodule