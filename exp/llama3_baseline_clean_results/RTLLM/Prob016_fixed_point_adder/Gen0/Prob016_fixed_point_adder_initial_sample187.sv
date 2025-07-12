module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

// Internal register to store the result
reg [N-1:0] res;

// Determine the sign of a and b
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Absolute values of a and b (without sign bit)
wire [N-2:0] a_abs = a[N-2:0];
wire [N-2:0] b_abs = b[N-2:0];

// Compare absolute values to determine larger one
wire a_greater = (a_abs > b_abs) | (a_abs == b_abs && a_sign == 1'b0);
wire b_greater = ~a_greater;

// Result calculation based on signs and comparison
always @(*) begin
    if (a_sign == b_sign) begin // Same signs, add absolute values
        res = {a_sign, a_abs} + {b_sign, b_abs};
    end else begin // Different signs, subtract smaller from larger
        if (a_greater) begin
            res = {1'b0, a_abs} - {1'b0, b_abs};
        end else begin
            res = {1'b0, b_abs} - {1'b0, a_abs};
        end
    end
end

// Assign result to output
assign c = res;

endmodule