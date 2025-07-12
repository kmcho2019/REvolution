module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Calculate the sign bits of a and b
    logic sign_a = a[N-1];
    logic sign_b = b[N-1];

    // Perform subtraction or addition based on the sign bits
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (~sign_a && sign_b) begin
            // a is positive, b is negative
            res = a + (~b + 1);  // Two's complement of b
        end else begin
            // a is negative, b is positive
            res = (~a + 1) + b;  // Two's complement of a
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        res = {1'b0, {N-1{1'b0}}};
    end

    // Assign the result to the output port
    c = res;
end

endmodule