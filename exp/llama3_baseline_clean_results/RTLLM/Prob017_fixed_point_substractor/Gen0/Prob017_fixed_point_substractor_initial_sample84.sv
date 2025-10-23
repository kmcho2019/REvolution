module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Extract the sign bits of the input operands
    reg a_sign = a[N-1];
    reg b_sign = b[N-1];

    // Perform subtraction based on the signs of the input operands
    if (a_sign == b_sign) begin
        // Same sign subtraction
        res = a - b;
    end else if (a_sign == 0 && b_sign == 1) begin
        // a is positive, b is negative
        res = a + (~b + 1);
    end else begin
        // a is negative, b is positive
        res = (~a + 1) + b;
    end

    // Handle zero result
    if (res == 0) begin
        res = 0;  // Explicitly set the sign bit to 0
    end
end

assign c = res;

endmodule