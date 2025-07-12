module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16   // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

// Determine the sign bits of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Determine the absolute values of the input operands
wire [N-1:0] abs_a = sign_a? ~a + 1 : a;
wire [N-1:0] abs_b = sign_b? ~b + 1 : b;

// Perform absolute value addition or subtraction based on the sign bits
always @(*) begin
    if (sign_a == sign_b) begin  // Same sign, perform addition
        res = abs_a + abs_b;
    end else begin  // Different signs, perform subtraction
        if (abs_a > abs_b) begin
            res = abs_a - abs_b;
        end else begin
            res = abs_b - abs_a;
        end
    end
end

// Assign the result to the output port, considering the sign bit
always @(*) begin
    if (sign_a == sign_b) begin  // Same sign, set the sign bit of the result accordingly
        c = sign_a? ~res + 1 : res;
    end else begin  // Different signs, set the sign bit of the result based on the larger absolute value
        if (abs_a > abs_b) begin
            c = res;
        end else begin
            c = ~res + 1;
        end
    end
end

endmodule