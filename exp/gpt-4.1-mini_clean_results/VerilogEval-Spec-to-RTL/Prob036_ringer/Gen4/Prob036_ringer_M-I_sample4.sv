`default_nettype none

module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// When ringing is active and not in vibrate mode, enable ringer
assign ringer = ring & ~vibrate_mode;

// When ringing is active and vibrate mode is enabled, enable motor
assign motor  = ring &  vibrate_mode;

endmodule

`default_nettype wire