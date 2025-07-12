module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Simplified logic using ternary operator for concise representation
always @(ring, vibrate_mode) begin
    ringer = ring && !vibrate_mode;
    motor = ring && vibrate_mode;
end

endmodule