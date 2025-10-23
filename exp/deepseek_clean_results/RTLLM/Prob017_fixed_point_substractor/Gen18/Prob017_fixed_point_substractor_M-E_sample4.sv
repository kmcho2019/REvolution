module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Convert inputs to two's complement form
    wire [N:0] a_tc = a[N-1] ? {1'b1, ~a[N-2:0]} + 1'b1 : {1'b0, a[N-2:0]};
    wire [N:0] b_tc = b[N-1] ? {1'b1, ~b[N-2:0]} + 1'b1 : {1'b0, b[N-2:0]};

    // Perform subtraction with extra bit for overflow
    wire [N:0] res_tc = a_tc - b_tc;

    // Check for zero result (all bits including sign are zero)
    wire is_zero = (res_tc == 0);

    // Convert back to sign-magnitude representation
    wire res_sign = res_tc[N];
    wire [N-2:0] res_mag = res_sign ? -res_tc[N-1:0] : res_tc[N-1:0];

    // Final result with zero handling
    assign c = is_zero ? {N{1'b0}} : {res_sign, res_mag};

endmodule