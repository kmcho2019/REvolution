module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// This module controls a cellphone's ringer and vibration motor based on the ring input and vibrate_mode.
always_comb begin
    // If the phone is ringing, turn on the ringer or motor based on the vibrate_mode.
    if (ring) begin
        // If the phone is in vibrate mode, turn on the motor; otherwise, turn on the ringer.
        ringer = ~vibrate_mode;
        motor = vibrate_mode;
    end else begin
        // If the phone is not ringing, turn off both the ringer and motor.
        ringer = 0;
        motor = 0;
    end
end

endmodule