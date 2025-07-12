module TopModule (
    input ring,            // Incoming call signal
    input vibrate_mode,    // Phone vibration setting
    output ringer,         // Ringer control output
    output motor           // Vibration motor control
);

    // Ringer activates when ring is high and not in vibrate mode
    assign ringer = ring & ~vibrate_mode;
    
    // Motor activates when ring is high and in vibrate mode
    assign motor = ring & vibrate_mode;

endmodule