module TopModule (
    input ring,            // Incoming call signal
    input vibrate_mode,    // Phone vibration setting
    output ringer,         // Ringer control output
    output motor           // Vibration motor control
);

    // Motor activates when both ring and vibrate_mode are high
    assign motor = ring & vibrate_mode;
    
    // Ringer activates when ring is high but motor isn't (not in vibrate mode)
    assign ringer = ring & ~motor;  // Equivalent to ring & ~vibrate_mode

endmodule