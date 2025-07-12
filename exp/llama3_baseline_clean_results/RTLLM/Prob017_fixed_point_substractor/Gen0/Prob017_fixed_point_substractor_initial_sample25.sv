module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Check if the signs of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1'b0) begin // a is positive
            if (a >= (~b + 1)) begin // a is greater than or equal to the absolute value of b
                res = a + (~b + 1); // Add the absolute values, result is positive
            end else begin
                res = (~b + 1) - a; // Subtract, result is negative
                res = ~res + 1; // Two's complement to represent negative number
            end
        end else begin // a is negative
            if ((~a + 1) >= b) begin // Absolute value of a is greater than or equal to b
                res = (~a + 1) + b; // Add the absolute values, result is negative
                res = ~res + 1; // Two's complement to represent negative number
            end else begin
                res = b - (~a + 1); // Subtract, result is positive
            end
        end
    end
    
    // Handle zero result explicitly
    if (res == 0) begin
        res[N-1] = 1'b0; // Ensure sign bit is 0 for zero result
    end
end

assign c = res;

endmodule