module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Use assign statements for continuous assignments
assign ringer = ring & ~vibrate_mode;
assign motor = ring & vibrate_mode;

endmodule