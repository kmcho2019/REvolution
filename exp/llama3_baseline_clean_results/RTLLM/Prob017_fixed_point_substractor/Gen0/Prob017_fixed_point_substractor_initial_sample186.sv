module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Check if a and b have the same sign
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            if (a >= (~b + 1)) begin
                // a is greater than or equal to b, result is positive
                res = a + (~b + 1);
            end else begin
                // a is less than b, result is negative
                res = (~a + 1) + b;
            end
        end else begin
            // a is negative, b is positive
            if ((~a + 1) >= b) begin
                // a is less than or equal to b, result is negative
                res = (~a + 1) + b;
            end else begin
                // a is greater than b, result is positive
                res = a + (~b + 1);
            end
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        res = 0; // Explicitly set the sign bit to 0
    end
end

assign c = res;

endmodule