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

// Perform same sign subtraction
wire [N-1:0] same_sign_res = sign_a? -a + -b : a - b;

// Perform different sign subtraction
wire [N-1:0] different_sign_res = sign_a? -a + b : a + -b;

// Handle the result based on the signs of the input operands
always @(*) begin
    if (sign_a == sign_b) begin
        res = same_sign_res;
    end else begin
        res = different_sign_res;
        // Explicitly set the sign bit to 0 when the result is zero
        if (res == 0) begin
            res[N-1] = 0;
        end
    end
end

// Assign the result to the output port
assign c = res;

endmodule