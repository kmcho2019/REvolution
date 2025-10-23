module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

assign ringer = ~vibrate_mode & ring;
assign motor = vibrate_mode & ring;

endmodule