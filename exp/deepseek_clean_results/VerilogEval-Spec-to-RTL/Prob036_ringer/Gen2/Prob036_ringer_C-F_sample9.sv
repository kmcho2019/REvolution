module TopModule (
    input ring,          // Incoming call signal
    input vibrate_mode,  // Vibration mode setting
    output ringer,       // Ringer control (active when ring=1 and vibrate_mode=0)
    output motor         // Motor control (active when both inputs are 1)
);

    // Ringer activates only in normal mode (vibrate_mode=0) during incoming call
    assign ringer = ring & ~vibrate_mode;
    
    // Motor activates only in vibrate mode (vibrate_mode=1) during incoming call
    assign motor = ring & vibrate_mode;

endmodule