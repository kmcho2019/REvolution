module TopModule(
    input  ring,
    input  vibrate_mode,
    output ringer,
    output motor
);
    
    // Continuous assignment to set motor and ringer based on inputs
    assign motor = ring & vibrate_mode;
    assign ringer = ring & ~vibrate_mode;

endmodule