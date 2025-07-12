module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Determine if signs are same
    wire signs_same = ~(a[N-1] ^ b[N-1]);

    // Compute result based on sign comparison
    assign c = signs_same ? a + b : 
               (a[N-1] ? b - a : a - b);

endmodule