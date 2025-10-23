module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result of the addition or subtraction

// Determine the sign of the input operands
wire sign_a = a[N-1];  // Sign bit of operand a
wire sign_b = b[N-1];  // Sign bit of operand b

// Calculate the absolute values of the input operands
wire [N-1:0] abs_a = sign_a ? -a : a;  // Absolute value of operand a
wire [N-1:0] abs_b = sign_b ? -b : b;  // Absolute value of operand b

// Perform absolute value addition or subtraction based on the signs of a and b
always @(*) begin
    if (sign_a == sign_b) begin  // Both positive or both negative
        res = abs_a + abs_b;  // Absolute value addition
    end else begin  // One is positive, the other is negative
        if (abs_a > abs_b) begin  // a is greater than b
            res = abs_a - abs_b;  // a - b
        end else begin  // b is greater than a
            res = abs_b - abs_a;  // b - a
        end
    end
end

// Assign the result to the output, considering the sign
always @(*) begin
    if (sign_a == sign_b) begin  // Both positive or both negative
        c = sign_a ? -res : res;  // Set the sign of the result to match the signs of a and b
    end else begin  // One is positive, the other is negative
        if (abs_a > abs_b) begin  // a is greater than b
            c = res;  // Positive result
        end else begin  // b is greater than a
            c = sign_b ? -res : res;  // Set the sign of the result based on the sign of b
        end
    end
end

endmodule