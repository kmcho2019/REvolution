module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];

    // Zero detection
    wire a_zero = ~(|a[N-2:0]);
    wire b_zero = ~(|b[N-2:0]);

    // Magnitude comparison
    wire a_larger = (a_mag > b_mag) || b_zero;

    // Sign determination
    wire same_sign = ~(a_sign ^ b_sign);
    wire result_sign = same_sign ? a_sign : 
                     (a_sign ? !a_larger : a_larger);

    // Two's complement subtraction
    wire [N-1:0] diff = {1'b0, a_mag} - {1'b0, b_mag};
    wire [N-2:0] result_mag = diff[N-2:0];

    // Zero result handling
    wire is_zero = ~(|result_mag);

    // Final output assembly
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : 
               {result_sign, result_mag};

endmodule