module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

// Internal 2-bit mode representation
wire [1:0] mode = {vibrate_mode, ring};

// Decoder logic
wire ringer_en = (mode == 2'b01);  // Ring only when not in vibrate mode
wire motor_en  = (mode == 2'b11);  // Vibrate when in vibrate mode and ringing

// Output assignments
assign ringer = ringer_en;
assign motor  = motor_en;

endmodule