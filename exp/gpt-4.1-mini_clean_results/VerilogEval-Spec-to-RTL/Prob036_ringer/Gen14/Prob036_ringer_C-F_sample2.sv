module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// When ringing and vibrate_mode is active, enable the vibration motor only
assign motor  = ring & vibrate_mode;

// When ringing and vibrate_mode is inactive, enable the ringer only
assign ringer = ring & ~vibrate_mode;

endmodule