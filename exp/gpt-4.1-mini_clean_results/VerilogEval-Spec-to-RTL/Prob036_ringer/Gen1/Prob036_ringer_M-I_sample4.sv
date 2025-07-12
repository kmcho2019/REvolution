module TopModule(
    input wire ring,
    input wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// Using XOR to avoid explicit NOT gate on vibrate_mode
assign ringer = ring & (vibrate_mode ^ 1'b1);
assign motor  = ring & vibrate_mode;

endmodule