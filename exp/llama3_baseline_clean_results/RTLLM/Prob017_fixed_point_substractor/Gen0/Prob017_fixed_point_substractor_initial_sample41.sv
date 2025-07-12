module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a, b) begin
    // Determine the signs of a and b
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];
    
    // Same sign subtraction
    if (sign_a == sign_b) begin
        // Perform subtraction
        res = a - b;
        // Correctly handle the sign of the result
        if (res == 0) begin
            res[N-1] = 0; // Ensure sign bit is 0 for zero result
        end
    end
    // Different sign subtraction
    else begin
        // Perform addition of absolute values and determine the sign of the result
        if (~sign_a && sign_b) begin // a is negative, b is positive
            if (a[N-1:0] > b[N-1:0]) begin
                res = a + (~b + 1); // 2's complement of b
                res[N-1] = 1; // Result is negative
            end else begin
                res = b + (~a + 1); // 2's complement of a
                res[N-1] = 0; // Result is positive
            end
        end else begin // a is positive, b is negative
            if (a[N-1:0] > b[N-1:0]) begin
                res = a + (~b + 1); // 2's complement of b
                res[N-1] = 0; // Result is positive
            end else begin
                res = b + (~a + 1); // 2's complement of a
                res[N-1] = 1; // Result is negative
            end
        end
    end
end

assign c = res;

endmodule