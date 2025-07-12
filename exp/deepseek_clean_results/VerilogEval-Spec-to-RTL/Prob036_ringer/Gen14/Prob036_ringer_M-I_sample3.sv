module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    wire not_vibrate = ~vibrate_mode;
    
    assign ringer = ring & not_vibrate;
    assign motor  = ring & vibrate_mode;

endmodule