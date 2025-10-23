module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

// Determine the signs of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Determine if the signs are the same
wire same_sign = (sign_a == sign_b);

// Perform same sign subtraction
wire [N-1:0] same_sign_result = (sign_a == 1'b0)? (a - b) : (b - a);

// Perform different sign subtraction
wire [N-1:0] different_sign_result = (sign_a == 1'b0)? (a + (~b + 1'b1)) : ((~a + 1'b1) + b);

// Handle the edge case where the result is zero
wire [N-1:0] zero_result = (res == {N{1'b0}})? {N-1{1'b0}} : res;

always @(*) begin
    // Perform same sign subtraction
    if (same_sign) begin
        res = same_sign_result;
    // Perform different sign subtraction
    end else begin
        res = different_sign_result;
    end
    
    // Handle the edge case where the result is zero
    if (res == {N{1'b0}}) begin
        c = {N-1{1'b0}};
    end else begin
        c = res;
    end
end

endmodule