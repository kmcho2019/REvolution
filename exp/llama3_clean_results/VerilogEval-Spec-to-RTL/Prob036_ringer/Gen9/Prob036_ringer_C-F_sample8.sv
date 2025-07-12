module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

// Define the combinational logic using an always_comb block
always_comb begin
    // If the ring input is high, assign values to ringer and motor based on vibrate_mode
    if (ring) begin
        ringer = ~vibrate_mode; // Turn on ringer if not in vibrate mode
        motor = vibrate_mode; // Turn on motor if in vibrate mode
    end else begin
        // If the ring input is low, set both ringer and motor to 0
        ringer = 1'b0;
        motor = 1'b0;
    end
end

endmodule