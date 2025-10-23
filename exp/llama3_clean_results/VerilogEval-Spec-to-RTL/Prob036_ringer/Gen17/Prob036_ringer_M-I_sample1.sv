// The provided solution is already optimized in terms of logic operations.
// Hence, we will focus on ensuring the code adheres to best practices for synthesis and readability.
module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Directly assign outputs based on inputs, maintaining simplicity and efficiency.
assign ringer = ring && ~vibrate_mode;
assign motor = ring && vibrate_mode;

endmodule