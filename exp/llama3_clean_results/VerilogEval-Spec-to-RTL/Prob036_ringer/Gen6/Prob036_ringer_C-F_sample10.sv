module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Direct assignments using conditional operators for concise logic expressions
assign ringer = ring ? ~vibrate_mode : 1'b0;
assign motor = ring ? vibrate_mode : 1'b0;

endmodule