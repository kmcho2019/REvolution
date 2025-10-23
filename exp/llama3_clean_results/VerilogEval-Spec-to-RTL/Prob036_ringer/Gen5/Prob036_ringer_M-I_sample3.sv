module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Utilizing conditional operator for concise logic expression
assign ringer = ring ? ~vibrate_mode : 1'b0;
assign motor = ring ? vibrate_mode : 1'b0;

endmodule