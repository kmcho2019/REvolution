module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

// Determine if the operands are positive or negative based on their MSBs
wire a_is_negative = a[N-1];
wire b_is_negative = b[N-1];

// Calculate the absolute values of the operands
wire [N-1:0] abs_a = a_is_negative? -a : a;
wire [N-1:0] abs_b = b_is_negative? -b : b;

// Perform addition or subtraction based on the signs of the operands
always @(*) begin
    if (a_is_negative == b_is_negative) begin
        // Same sign: add absolute values and keep the sign consistent
        res = (a_is_negative)? -(abs_a + abs_b) : (abs_a + abs_b);
    end else begin
        // Different signs: subtract the smaller absolute value from the larger one
        if (abs_a > abs_b) begin
            res = a_is_negative? -(abs_a - abs_b) : (abs_a - abs_b);
        end else begin
            res = b_is_negative? -(abs_b - abs_a) : (abs_b - abs_a);
        end
    end
end

// Assign the result to the output
assign c = res;

endmodule