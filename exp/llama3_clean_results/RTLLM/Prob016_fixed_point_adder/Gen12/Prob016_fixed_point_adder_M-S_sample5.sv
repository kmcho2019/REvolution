module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

    wire [N-1:0] abs_a, abs_b;
    wire sign_a, sign_b;
    wire add_sub; // 1 for addition, 0 for subtraction

    // Calculate absolute values and detect signs
    assign abs_a = a[N-1] ? (~a + 1) : a;
    assign abs_b = b[N-1] ? (~b + 1) : b;
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];
    assign add_sub = sign_a == sign_b;

    // Perform addition or subtraction based on signs
    wire [N:0] result;
    assign result = add_sub ? (abs_a + abs_b) : (abs_a > abs_b) ? (abs_a - abs_b) : (abs_b - abs_a);

    // Apply sign to result and handle overflow
    assign c = (result[N] && sign_a) ? {N{1'b1}} : (result[N] && ~sign_a) ? {N{1'b0}} : result[N-1:0];

endmodule