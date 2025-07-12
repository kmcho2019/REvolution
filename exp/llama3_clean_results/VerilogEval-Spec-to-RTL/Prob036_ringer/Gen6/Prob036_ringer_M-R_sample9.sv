module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Always block to handle changes in input signals
always @(ring, vibrate_mode) begin
    // If the phone is ringing
    if (ring) begin
        // In vibrate mode, turn on the motor; otherwise, turn on the ringer
        if (vibrate_mode) begin
            ringer = 1'b0; // Ensure ringer is off
            motor = 1'b1;  // Turn on motor
        end else begin
            ringer = 1'b1; // Turn on ringer
            motor = 1'b0;  // Ensure motor is off
        end
    end else begin
        // If not ringing, ensure both outputs are off
        ringer = 1'b0;
        motor = 1'b0;
    end
end

endmodule