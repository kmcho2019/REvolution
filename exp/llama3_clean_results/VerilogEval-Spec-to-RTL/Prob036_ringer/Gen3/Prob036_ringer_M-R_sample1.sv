module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

assign motor = ring && vibrate_mode;
assign ringer = ring && ~vibrate_mode;

endmodule