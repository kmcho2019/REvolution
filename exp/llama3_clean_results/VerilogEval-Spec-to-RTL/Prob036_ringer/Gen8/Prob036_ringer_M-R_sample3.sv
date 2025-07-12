module TopModule(
    input ring,
    input vibrate_mode,
    output logic ringer,
    output logic motor
);

always @(*) begin
    // Conditional logic using if-else statement
    if (ring) begin
        ringer = ~vibrate_mode;
        motor = vibrate_mode;
    end else begin
        ringer = 1'b0;
        motor = 1'b0;
    end
end

endmodule