module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)
(
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c   // N-bit output representing the result
);

// Internal register to store the result of the subtraction operation
reg [N-1:0] res;

// Determine the signs of the input operands
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Perform subtraction based on the signs
always @(a, b) begin
    if (a_sign == b_sign) begin  // Same sign subtraction
        res = a - b;
    end else begin  // Different sign subtraction
        if (a_sign == 1'b0 && b_sign == 1'b1) begin  // a is positive, b is negative
            res = a + (~b + 1'b1);  // Add the absolute values
        end else if (a_sign == 1'b1 && b_sign == 1'b0) begin  // a is negative, b is positive
            res = (~a + 1'b1) + b;  // Add the absolute values
        end
    end

    // Handle the case when the result is zero
    if (res == {N{1'b0}}) begin
        res[N-1] = 1'b0;  // Explicitly set the sign bit to 0
    end
end

// Assign the result to the output port
assign c = res;

endmodule