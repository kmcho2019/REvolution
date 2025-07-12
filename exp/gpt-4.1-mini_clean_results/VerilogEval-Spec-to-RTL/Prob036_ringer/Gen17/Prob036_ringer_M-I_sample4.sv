module TopModule(
    input  wire ring,           // Incoming call indicator
    input  wire vibrate_mode,   // Vibrate mode selector
    output wire ringer,         // Ringer output (sound)
    output wire motor           // Vibration motor output
);

// Gate outputs with ring signal to reduce toggling when no ring
assign motor  = ring & vibrate_mode;
assign ringer = ring & ~vibrate_mode;

endmodule