module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Using basic AND gates and ensuring minimal logic for area efficiency
assign ringer = ~vibrate_mode & ring;
assign motor = vibrate_mode & ring;

endmodule