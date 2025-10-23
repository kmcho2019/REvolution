module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Compute sum and absolute difference
    wire [N-1:0] sum = a + b;
    wire [N-2:0] abs_diff = (a[N-2:0] > b[N-2:0]) ? 
                           (a[N-2:0] - b[N-2:0]) : 
                           (b[N-2:0] - a[N-2:0]);

    // Determine result based on sign bits
    assign c = (a[N-1] == b[N-1]) ? sum :               // Same sign: add
               (a[N-2:0] == b[N-2:0]) ? {1'b0, {N-1{1'b0}}} :  // Equal magnitude: zero
               {((a[N-2:0] > b[N-2:0]) ? a[N-1] : b[N-1]), abs_diff};  // Different sign: subtract

endmodule