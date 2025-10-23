module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Directly assign output values based on input conditions
assign motor = ring & vibrate_mode;
assign ringer = ring & ~vibrate_mode;

endmodule