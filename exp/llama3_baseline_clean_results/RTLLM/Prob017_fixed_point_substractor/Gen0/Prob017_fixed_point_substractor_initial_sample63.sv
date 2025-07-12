module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;

// Determine sign bits of a and b
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform same sign subtraction
wire same_sign = sign_a == sign_b;
wire [N-1:0] same_sign_result = a - b;

// Perform different sign subtraction
wire different_sign = ~same_sign;
wire [N-1:0] abs_a = sign_a ? -a : a;
wire [N-1:0] abs_b = sign_b ? -b : b;
wire [N-1:0] different_sign_result = abs_a + abs_b;

// Determine sign of result for different sign subtraction
wire result_sign = (abs_a >= abs_b) ? ~sign_a : sign_b;

// Handle edge case where result is zero
wire result_zero = (same_sign_result == 0) || (different_sign_result == 0);

// Combine results
always @(*) begin
    if (same_sign) begin
        res = same_sign_result;
    end else if (different_sign) begin
        res = result_sign ? -different_sign_result : different_sign_result;
    end
    
    // Handle edge case where result is zero
    if (result_zero) begin
        res[N-1] = 0;
    end
end

// Assign output
assign c = res;

endmodule