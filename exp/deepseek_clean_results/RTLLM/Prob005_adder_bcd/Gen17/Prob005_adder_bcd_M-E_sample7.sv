module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Prediction logic: Will the sum require correction?
    // This looks at the inputs rather than waiting for the sum result
    wire potential_overflow = (A > 4'd9) | (B > 4'd9) |  // Inputs already invalid
                            ((A == 4'd9) & (B != 4'd0)) |  // 9 + anything but 0
                            ((A >= 4'd5) & (B >= 4'd5));   // Both >=5 will sum to >=10

    // Compute both possible sums in parallel
    wire [4:0] raw_sum = A + B + Cin;
    wire [4:0] corrected_sum = A + B + Cin + 4'd6;

    // Select appropriate result based on prediction
    assign {Cout, Sum} = potential_overflow ? corrected_sum : raw_sum;

    // Final validation (can be optimized out in synthesis)
    always @(*) begin
        if (Sum > 4'd9) $display("Warning: BCD validation failed");
    end

endmodule