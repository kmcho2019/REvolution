module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
) (
    input   [N-1:0] a, // First N-bit fixed-point input operand
    input   [N-1:0] b, // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(a or b) begin
    // Determine the sign bits of inputs a and b
    reg a_sign = a[N-1];
    reg b_sign = b[N-1];

    // Compare the absolute values of a and b
    reg [N-1:0] a_abs = (a_sign) ? (~a + 1) : a; // Two's complement
    reg [N-1:0] b_abs = (b_sign) ? (~b + 1) : b; // Two's complement

    if (a_sign == b_sign) begin // Both positive or both negative
        // Absolute value addition
        res = (a_sign) ? -(a_abs + b_abs) : (a_abs + b_abs); // Perform two's complement addition
    end else begin // One positive, one negative
        if (a_abs > b_abs) begin // a is greater than b
            // Absolute value subtraction
            res = (a_sign) ? -(a_abs - b_abs) : (a_abs - b_abs); // Perform two's complement subtraction
        end else if (a_abs < b_abs) begin // b is greater than a
            // Absolute value subtraction
            res = (b_sign) ? -(b_abs - a_abs) : (b_abs - a_abs); // Perform two's complement subtraction
        end else begin // a and b are equal
            res = 0; // Result is zero
        end
    end
end

assign c = res; // Output the result

endmodule