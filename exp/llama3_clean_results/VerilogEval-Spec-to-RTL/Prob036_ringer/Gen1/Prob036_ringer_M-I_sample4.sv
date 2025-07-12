module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

// Using a single conditional statement for better readability
assign ringer = ring ? ~vibrate_mode : 0;
assign motor = ring ? vibrate_mode : 0;

endmodule