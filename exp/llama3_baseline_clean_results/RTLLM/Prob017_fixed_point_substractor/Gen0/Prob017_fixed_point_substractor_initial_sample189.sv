module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input  [N-1:0] a,  // First fixed-point input operand
    input  [N-1:0] b,  // Second fixed-point input operand
    output [N-1:0] c   // Fixed-point output representing the result
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine the signs of the operands
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Perform subtraction based on the signs
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (sign_a == 1'b0 && sign_b == 1'b1) begin
            // a is positive, b is negative
            if (a > (~b + 1'b1)) begin
                res = a + (~b + 1'b1);
            end else begin
                res = (~b + 1'b1) - a;
                // Invert all bits and add 1 to get the two's complement
                res = ~res + 1'b1;
            end
        end else begin
            // a is negative, b is positive
            if ((~a + 1'b1) > b) begin
                res = (~a + 1'b1) - b;
                // Invert all bits and add 1 to get the two's complement
                res = ~res + 1'b1;
            end else begin
                res = b - (~a + 1'b1);
            end
        end
    end

    // Handle the case when the result is zero
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule