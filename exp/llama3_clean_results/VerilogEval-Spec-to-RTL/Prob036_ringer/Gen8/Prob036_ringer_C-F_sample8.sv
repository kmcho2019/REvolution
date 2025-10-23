module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

always @(ring, vibrate_mode) begin
    // Use conditional operators within the always block for conciseness and efficiency
    ringer = ring ? ~vibrate_mode : 0;
    motor = ring ? vibrate_mode : 0;
end

endmodule