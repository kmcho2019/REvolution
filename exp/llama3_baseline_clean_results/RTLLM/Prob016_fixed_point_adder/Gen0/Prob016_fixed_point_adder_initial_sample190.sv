module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // N-bit register to store the result

// Determine the sign of the input operands
wire sign_a = a[N-1]; // Sign bit of operand a
wire sign_b = b[N-1]; // Sign bit of operand b

// Compare the absolute values of the input operands
wire [N-1:0] abs_a = sign_a ? -a : a; // Absolute value of operand a
wire [N-1:0] abs_b = sign_b ? -b : b; // Absolute value of operand b

// Perform the arithmetic operation (addition or subtraction)
always @(*) begin
    if (sign_a == sign_b) begin // Both operands have the same sign
        res = a + b; // Perform addition
    end else begin // Operands have different signs
        if (abs_a > abs_b) begin // a is greater than b
            res = a - b; // Perform subtraction
        end else begin // b is greater than a
            res = b - a; // Perform subtraction
        end
    end
end

// Set the output port
assign c = res;

endmodule