module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Sign detection stage
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Absolute value computation
wire [N-1:0] abs_a = sign_a? ~a + 1 : a;
wire [N-1:0] abs_b = sign_b? ~b + 1 : b;

// Comparison and result sign determination
wire result_sign = (sign_a == sign_b)? sign_a : (abs_a < abs_b)? ~sign_a : sign_a;

// Core computation stage
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        c = a - b;
    end else if (abs_a >= abs_b) begin
        // a is larger, perform subtraction
        c = a - b;
    end else begin
        // b is larger, perform subtraction with sign adjustment
        c = ~((~a + 1) - (~b + 1)) + 1;
    end
end

// Ensure the result's sign bit is correctly set
assign c[N-1] = result_sign;

endmodule