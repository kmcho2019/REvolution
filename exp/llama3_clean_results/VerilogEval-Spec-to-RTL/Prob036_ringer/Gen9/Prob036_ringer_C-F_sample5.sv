module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

assign ringer = ring ? !vibrate_mode : 0;
assign motor = ring ? vibrate_mode : 0;

endmodule