module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

// Create a 2-bit control word:
// [1] = ring enabled
// [0] = vibrate_mode active
wire [1:0] control = {ring, vibrate_mode};

// Decode control word to outputs
assign ringer = (control == 2'b10);  // Ring only when not in vibrate mode
assign motor  = (control == 2'b11);  // Ring and vibrate mode active

endmodule