module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register to store the result

// Determine the sign bits of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform absolute value addition or subtraction based on the sign bits
always @(a, b) begin
    if (sign_a == sign_b) begin // Same signs, perform addition
        // Add the absolute values
        res = (a[N-1] == 1'b0) ? (a + b) : (-a + (-b));
    end else begin // Different signs, perform subtraction
        // Compare the absolute values and perform subtraction
        if (($signed(a) > $signed(b))) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
end

// Assign the result to the output port
assign c = res;

endmodule