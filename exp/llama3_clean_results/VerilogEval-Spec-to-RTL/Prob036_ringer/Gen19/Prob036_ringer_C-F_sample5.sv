module TopModule(
    input logic ring,
    input logic vibrate_mode,
    output logic ringer,
    output logic motor
);

// Using assign for continuous assignment and direct logical operations for simplicity and efficiency
assign ringer = ring && !vibrate_mode;
assign motor = ring && vibrate_mode;

endmodule