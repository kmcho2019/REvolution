module TopModule(
    input  wire ring,           // Incoming call indicator
    input  wire vibrate_mode,   // Vibrate mode selector
    output wire ringer,         // Ringer output (sound)
    output wire motor           // Vibration motor output
);

// Turn on motor only if ringing and vibrate mode active
assign motor  = ring & vibrate_mode;

// Turn on ringer only if ringing and vibrate mode inactive
assign ringer = ring & ~vibrate_mode;

endmodule