module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Direct assignment of outputs based on input conditions
assign ringer = ~vibrate_mode & ring;
assign motor = vibrate_mode & ring;

endmodule