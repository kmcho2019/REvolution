module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Determine the sign of the inputs
    reg sign_a, sign_b;
    assign sign_a = a[N-1]; // Sign bit of a
    assign sign_b = b[N-1]; // Sign bit of b

    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (sign_a == 0) begin // a is positive
            if (a >= b) begin
                res = a + (~b + 1); // Add absolute values, considering two's complement for b
            end else begin
                res = (~a + 1) + b; // Add absolute values, considering two's complement for a
                res = ~res + 1; // Negate the result since a < b
            end
        end else begin // a is negative
            if (a <= b) begin
                res = a + b; // Considering two's complement for both a and b
            end else begin
                res = (~b + 1) + a; // Add absolute values, considering two's complement for b
                res = ~res + 1; // Negate the result since a > b
            end
        end
    end

    if (res == 0) begin
        // Handle the edge case where the result is zero
        res = 0;
    end

    c = res;
end

endmodule