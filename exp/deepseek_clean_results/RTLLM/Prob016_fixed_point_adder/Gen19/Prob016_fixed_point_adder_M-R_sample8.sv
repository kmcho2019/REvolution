module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitudes (without sign bits)
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Comparison signals
    wire same_sign = (a_sign == b_sign);
    wire a_larger = (a_mag > b_mag);
    wire equal_mag = (a_mag == b_mag);
    
    // Intermediate results
    wire [N-2:0] abs_diff = a_larger ? (a_mag - b_mag) : (b_mag - a_mag);
    wire [N-1:0] sum = {a_sign, a_mag} + {b_sign, b_mag};
    
    // Result selection
    wire [N-1:0] result;
    assign result = same_sign ? sum :                     // Same sign: add
                   equal_mag ? {1'b0, {N-1{1'b0}}} :     // Equal magnitude: zero
                   {a_larger ? a_sign : b_sign, abs_diff}; // Different sign: subtract
    
    assign c = result;

endmodule