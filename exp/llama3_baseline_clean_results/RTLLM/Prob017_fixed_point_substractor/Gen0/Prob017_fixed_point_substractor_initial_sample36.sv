module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Check if the signs of 'a' and 'b' are the same
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 0) begin
            // 'a' is positive, 'b' is negative
            if (a >= -b) begin
                // 'a' is greater than or equal to '-b'
                res = a + ~b + 1; // Add the absolute values and determine the sign
            end else begin
                // '-b' is greater than 'a'
                res = ~(-b - a) + 1; // Subtract 'a' from '-b' and determine the sign
            end
        end else begin
            // 'a' is negative, 'b' is positive
            if (-a >= b) begin
                // '-a' is greater than or equal to 'b'
                res = ~(-a - b) + 1; // Subtract 'b' from '-a' and determine the sign
            end else begin
                // 'b' is greater than '-a'
                res = b + ~a + 1; // Add the absolute values and determine the sign
            end
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        res[N-1] = 0; // Explicitly set the sign bit to 0
    end
end

assign c = res; // Assign the result to the output

endmodule