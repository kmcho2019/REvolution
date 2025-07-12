module TopModule (
    input  wire phone_ring,        // Active-high incoming call signal
    input  wire vibration_enabled, // Active-high vibration mode setting
    output wire ringer_output,     // Active-high ringer control
    output wire motor_output       // Active-high vibration motor control
);

    // Ringer activates only when:
    // - There's an incoming call (phone_ring=1)
    // - Vibration mode is disabled (vibration_enabled=0)
    assign ringer_output = phone_ring & ~vibration_enabled;

    // Motor activates only when:
    // - There's an incoming call (phone_ring=1)
    // - Vibration mode is enabled (vibration_enabled=1)
    assign motor_output = phone_ring & vibration_enabled;

    // Note: The outputs are mutually exclusive by design
    //       since vibration_enabled and ~vibration_enabled cannot be true simultaneously

endmodule