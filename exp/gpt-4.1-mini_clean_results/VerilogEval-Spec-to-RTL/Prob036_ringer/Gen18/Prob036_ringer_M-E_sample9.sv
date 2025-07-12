module TopModule(
    input  wire ring,           // Incoming call indicator
    input  wire vibrate_mode,   // Vibrate mode selector
    output wire ringer,         // Ringer output (sound)
    output wire motor           // Vibration motor output
);

wire [1:0] signals_if_ring = 2'b10; // Bit 1: motor, Bit 0: ringer
wire [1:0] selected_signals;

// Use vibrate_mode as selector: 0 -> ringer (bit 0), 1 -> motor (bit 1)
// Assign outputs only if ring is active, else zero
assign selected_signals = ring ? (signals_if_ring & (2'b01 << vibrate_mode)) : 2'b00;

assign ringer = selected_signals[0];
assign motor  = selected_signals[1];

endmodule