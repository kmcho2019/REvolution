module fixed_point_subtractor #(
    parameter Q = 8,  // number of fractional bits
    parameter N = 16  // total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of a and b
    reg a_sign = a[N-1];
    reg b_sign = b[N-1];

    // Perform subtraction based on signs
    if (a_sign == b_sign) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a_sign == 0) begin
            // a is positive, b is negative
            res = a + (~b + 1);  // Add a and the two's complement of b
        end else begin
            // a is negative, b is positive
            res = (~a + 1) + b;  // Add the two's complement of a and b
        end
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 0;  // Set sign bit to 0 for zero result
    end

    c = res;
end

endmodule