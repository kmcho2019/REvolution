module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Use vibrate_mode as selector for a 2:1 mux
    assign ringer = ring & ~vibrate_mode;
    assign motor = ring & vibrate_mode;

    // Alternative implementation showing mux concept more explicitly
    // wire ringer_enable = ~vibrate_mode;
    // wire motor_enable = vibrate_mode;
    // assign ringer = ring & ringer_enable;
    // assign motor = ring & motor_enable;

endmodule