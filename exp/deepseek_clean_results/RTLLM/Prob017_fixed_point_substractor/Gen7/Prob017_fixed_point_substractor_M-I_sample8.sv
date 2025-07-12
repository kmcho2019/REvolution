module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    // Internal signals for sign comparison
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire same_sign = ~(a_sign ^ b_sign);

    always @(*) begin
        if (same_sign) begin
            // Same sign case: direct subtraction
            c = a - b;
        end else begin
            // Different signs: equivalent to addition of absolute values
            if (a_sign) begin
                // a negative, b positive
                c = b - (-a);  // Equivalent to b + |a|
            end else begin
                // a positive, b negative
                c = a - (-b);  // Equivalent to a + |b|
            end
        end

        // Explicit zero handling (sign bit clear)
        if (c == 0) c = 0;
    end

endmodule