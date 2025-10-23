module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the input operands
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Perform subtraction or addition based on the signs
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (sign_a == 1'b0 && sign_b == 1'b1) begin
            // a is positive and b is negative
            res = a + (~b + 1'b1);
        end else if (sign_a == 1'b1 && sign_b == 1'b0) begin
            // a is negative and b is positive
            res = (~a + 1'b1) + b;
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        res[N-1] = 1'b0;
    end
end

assign c = res;

endmodule