module TopModule (
    input ring,            // Incoming call signal
    input vibrate_mode,    // Vibration mode setting
    output ringer,         // Ringer control output
    output motor           // Vibration motor control output
);

    // Ringer activates when call comes in and not in vibrate mode
    assign ringer = ring & ~vibrate_mode;
    
    // Motor activates when call comes in and in vibrate mode
    assign motor = ring & vibrate_mode;

    // Note: Outputs are mutually exclusive by design
    // Only one can be active at any time when ring=1

endmodule