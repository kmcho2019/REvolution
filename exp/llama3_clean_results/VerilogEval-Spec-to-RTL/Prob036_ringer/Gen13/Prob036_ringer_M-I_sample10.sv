module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Directly assign outputs based on conditions to maintain simplicity and efficiency
assign ringer = ~vibrate_mode & ring;
assign motor = vibrate_mode & ring;

endmodule