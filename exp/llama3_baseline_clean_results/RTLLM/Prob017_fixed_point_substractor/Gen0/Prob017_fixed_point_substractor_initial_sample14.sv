module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   wire [N-1:0] a,
    input   wire [N-1:0] b,
    output  wire [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine the signs of a and b
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Same sign subtraction
    if (sign_a == sign_b) begin
        // Subtract b from a, maintaining the same sign
        res = a - b;
    end else begin
        // Different sign subtraction
        if (sign_a == 1'b0) begin  // a is positive, b is negative
            // Add the absolute values of a and b
            res = a + (~b + 1'b1);  // Two's complement of b
        end else begin  // a is negative, b is positive
            // Add the absolute values of a and b
            res = (~a + 1'b1) + b;  // Two's complement of a
        end
    end

    // Handle zero result explicitly
    if (res == {N{1'b0}}) begin
        c = {N{1'b0}};
    end else begin
        // Assign the result to the output
        c = res;
    end
end

endmodule