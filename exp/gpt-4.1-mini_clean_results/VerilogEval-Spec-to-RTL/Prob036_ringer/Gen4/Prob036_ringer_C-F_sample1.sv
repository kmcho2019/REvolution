module TopModule(
    input  ring,
    input  vibrate_mode,
    output ringer,
    output motor
);

wire enable = ring;

assign ringer = enable & ~vibrate_mode;
assign motor  = enable & vibrate_mode;

endmodule