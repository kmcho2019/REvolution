module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

// Turn on the motor if the phone is in vibrate mode and there's an incoming call
assign motor = ring & vibrate_mode;

// Turn on the ringer if there's an incoming call and the phone is not in vibrate mode
assign ringer = ring & ~vibrate_mode;

endmodule