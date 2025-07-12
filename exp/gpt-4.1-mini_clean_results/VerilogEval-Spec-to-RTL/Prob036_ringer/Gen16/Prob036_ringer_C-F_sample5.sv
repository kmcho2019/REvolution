module TopModule(
    input  wire ring,           // Incoming call signal
    input  wire vibrate_mode,   // Vibrate mode selector (1 = vibrate, 0 = ring)
    output wire ringer,         // Ringer output (sound)
    output wire motor           // Vibration motor output
);

// Signal indicating an active ring request
wire active = ring;

// Activate motor only if ringing and vibrate_mode is enabled
assign motor  = active & vibrate_mode;

// Activate ringer only if ringing and vibrate_mode is disabled
assign ringer = active & ~vibrate_mode;

endmodule