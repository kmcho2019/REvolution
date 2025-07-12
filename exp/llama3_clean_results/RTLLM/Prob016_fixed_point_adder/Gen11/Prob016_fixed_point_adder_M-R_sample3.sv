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
    assign abs_a = (a[N-1] == 1'b0)? a : (~a + 1);
    assign abs_b = (b[N-1] == 1'b0)? b : (~b + 1);
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];
    assign add_sub = (sign_a == sign_b)? 1'b1 : 1'b0;

    // Determine result based on operation
    wire [N-1:0] result;
    assign result = (add_sub == 1'b1)? (abs_a + abs_b) : (abs_a > abs_b)? (abs_a - abs_b) : (abs_b - abs_a);

    // Apply sign to result
    wire [N-1:0] signed_result;
    assign signed_result = (sign_a == 1'b1 && add_sub == 1'b1)? (~result + 1) : (sign_a == 1'b1 && add_sub == 1'b0 && abs_a > abs_b)? (~result + 1) : (sign_a == 1'b0 && add_sub == 1'b0 && abs_b > abs_a)? (~result + 1) : result;

    // Check for overflow and saturate if necessary
    assign c = (signed_result[N-1] != sign_a && add_sub == 1'b1)? (sign_a == 1'b1)? {N{1'b1}} : {N{1'b0}} : signed_result;

endmodule