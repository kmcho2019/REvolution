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
        case (vibrate_mode)
            1'b0: begin
                ringer = 1'b1;
                motor = 1'b0;
            end
            1'b1: begin
                ringer = 1'b0;
                motor = 1'b1;
            end
            default: begin
                ringer = 1'b0;
                motor = 1'b0;
            end
        endcase
    end else begin
        // If the phone is not ringing, turn off both the ringer and motor.
        ringer = 1'b0;
        motor = 1'b0;
    end
end

endmodule