module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the input operands
    logic sign_a = a[N-1];
    logic sign_b = b[N-1];

    // Perform same sign subtraction
    if (sign_a == sign_b) begin
        // Subtract the fractional and integer parts
        res = a - b;
    end else begin
        // Perform different sign subtraction
        if (sign_a == 1'b0 && sign_b == 1'b1) begin
            // Add the absolute values of a and b
            res = a + (~b + 1'b1);
        end else if (sign_a == 1'b1 && sign_b == 1'b0) begin
            // Subtract the absolute value of b from a
            res = (~a + 1'b1) + b;
        end
    end

    // Explicitly handle the case where the result is zero
    if (res == 0) begin
        res[N-1] = 1'b0;  // Set the sign bit to 0 for zero result
    end
end

assign c = res;

endmodule