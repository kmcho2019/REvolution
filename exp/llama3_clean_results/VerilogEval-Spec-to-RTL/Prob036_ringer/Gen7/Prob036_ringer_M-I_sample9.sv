module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Maintaining the existing logic for its simplicity and direct implementation of the required functionality.
assign ringer = ring ? ~vibrate_mode : 1'b0;
assign motor = ring ? vibrate_mode : 1'b0;

endmodule