module TopModule (
    input  ring,            // Incoming call signal
    input  vibrate_mode,    // Phone vibration mode setting
    output ringer,          // Ringer control output
    output motor            // Vibration motor control output
);

    // Ringer is active when there's an incoming call and not in vibrate mode
    assign ringer = ring & ~vibrate_mode;
    
    // Motor is active when there's an incoming call and in vibrate mode
    assign motor = ring & vibrate_mode;

endmodule