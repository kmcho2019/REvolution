module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

always_comb begin
    // Reset outputs to default (off) state
    ringer = 1'b0;
    motor = 1'b0;

    // If the phone needs to ring
    if (ring) begin
        // If in vibrate mode, turn on the motor; otherwise, turn on the ringer
        if (vibrate_mode) begin
            motor = 1'b1;
        end else begin
            ringer = 1'b1;
        end
    end
end

endmodule