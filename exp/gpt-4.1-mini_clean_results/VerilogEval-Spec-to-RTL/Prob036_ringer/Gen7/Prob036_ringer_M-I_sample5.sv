module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// When ring is active, select ringer or motor using vibrate_mode as select
assign ringer = ring & ~vibrate_mode;
assign motor  = ring & vibrate_mode;

endmodule