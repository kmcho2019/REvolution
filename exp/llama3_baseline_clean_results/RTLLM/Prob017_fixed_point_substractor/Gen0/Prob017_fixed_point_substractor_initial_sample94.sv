module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

// Determine the sign of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform the subtraction based on the sign of the operands
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction: subtract the absolute values
        res = a - b;
    end else begin
        // Different sign subtraction: add the absolute values
        if (a < b) begin
            // a is negative and b is positive, or a is positive and b is negative
            res = ~a + 1 + ~b + 1;
        end else begin
            // a is positive and b is negative
            res = a + ~b + 1;
        end
    end

    // Handle the zero result case
    if (res == 0) begin
        res[N-1] = 0;  // Explicitly set the sign bit to 0
    end
end

assign c = res;

endmodule