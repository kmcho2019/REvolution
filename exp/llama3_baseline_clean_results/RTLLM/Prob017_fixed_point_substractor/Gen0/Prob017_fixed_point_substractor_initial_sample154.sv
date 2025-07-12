module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    // Determine the signs of a and b
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Perform subtraction based on the signs
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else if (sign_a == 1'b0 && sign_b == 1'b1) begin
        // a is positive, b is negative
        if (a >= -b) begin
            res = a + (~b + 1); // Two's complement of b
        end else begin
            res = (~a + 1) + b; // Two's complement of a
            res = ~res + 1; // Take two's complement of the result
        end
    end else begin
        // a is negative, b is positive
        if (-a >= b) begin
            res = (~a + 1) + b; // Two's complement of a
            res = ~res + 1; // Take two's complement of the result
        end else begin
            res = a + (~b + 1); // Two's complement of b
        end
    end

    // Handle zero result case
    if (res == 0) begin
        res = {N{1'b0}};
    end
end

assign c = res;

endmodule