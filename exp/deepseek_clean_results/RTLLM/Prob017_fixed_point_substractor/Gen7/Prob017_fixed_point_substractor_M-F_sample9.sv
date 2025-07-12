module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal signals for absolute values
    wire signed [N-1:0] abs_a = a[N-1] ? -a : a;
    wire signed [N-1:0] abs_b = b[N-1] ? -b : b;
    
    // Determine if signs are different
    wire signs_differ = a[N-1] ^ b[N-1];
    
    // Calculate result based on sign cases
    wire signed [N-1:0] result;
    assign result = signs_differ ? 
                   (a[N-1] ? 
                    (abs_a > abs_b ? -(abs_a - abs_b) : (abs_b - abs_a)) :
                    (abs_a > abs_b ? (abs_a - abs_b) : -(abs_b - abs_a)))
                   : (a - b);
    
    // Final output with zero handling
    assign c = (result == 0) ? 0 : result;

endmodule