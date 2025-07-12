module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

// Determine the sign of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform subtraction based on the signs
always @(a or b) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign operation
        if (sign_a == 1'b0) begin
            // a is positive, b is negative
            if (a > ~b + 1'b1) begin
                // a is greater than b
                res = a + (~b + 1'b1);
            end else begin
                // b is greater than a
                res = (~b + 1'b1) - a;
                res = ~res + 1'b1;  // Two's complement for negative result
            end
        end else begin
            // a is negative, b is positive
            if (~a + 1'b1 > b) begin
                // a is greater than b (in absolute value)
                res = (~a + 1'b1) + b;
                res = ~res + 1'b1;  // Two's complement for negative result
            end else begin
                // b is greater than a
                res = b - (~a + 1'b1);
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        c[N-1] = 1'b0;  // Explicitly set sign bit to 0 for zero result
    end else begin
        c = res;
    end
end

endmodule