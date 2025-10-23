module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

// Direct gate-level implementation
assign ringer = ring & ~vibrate_mode;
assign motor  = ring & vibrate_mode;

endmodule