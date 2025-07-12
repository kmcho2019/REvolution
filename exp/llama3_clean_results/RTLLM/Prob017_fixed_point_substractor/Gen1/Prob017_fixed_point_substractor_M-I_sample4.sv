module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register to store the result of the subtraction operation

// Determine the signs of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform subtraction operation
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = sign_a? -a + -b : a - b;
    end else begin
        // Different sign subtraction
        res = sign_a? -a + b : a + -b;
    end
    
    // Explicitly set the sign bit to 0 when the result is zero
    if (res == 0) begin
        res[N-1] = 0;
    end
end

// Assign the result to the output port
assign c = res;

endmodule