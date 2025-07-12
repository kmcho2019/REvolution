module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Determine the signs of a and b
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Same sign subtraction
    if (sign_a == sign_b) begin
        // Perform subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (sign_a == 1'b0) begin // a is positive, b is negative
            if (a > (b ^ {N{1'b1}})) begin // a is greater than b
                res = a + (b ^ {N{1'b1}}) + 1'b1; // Add absolute values and set sign to positive
            end else begin
                res = (b ^ {N{1'b1}}) + 1'b1 - a; // Add absolute values and set sign to negative
                res = ~res + 1'b1; // Convert to two's complement
            end
        end else begin // a is negative, b is positive
            if ((a ^ {N{1'b1}}) + 1'b1 > b) begin // a is greater than b in absolute value
                res = (a ^ {N{1'b1}}) + 1'b1 - b; // Add absolute values and set sign to negative
                res = ~res + 1'b1; // Convert to two's complement
            end else begin
                res = b - ((a ^ {N{1'b1}}) + 1'b1); // Add absolute values and set sign to positive
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        res = {N{1'b0}}; // Set all bits to zero
    end

    // Assign result to output
    c = res;
end

endmodule