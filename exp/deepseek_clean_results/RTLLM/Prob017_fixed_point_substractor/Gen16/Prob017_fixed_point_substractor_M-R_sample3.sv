module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values (N-1 bits)
    wire [N-2:0] a_abs = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_abs = b_sign ? -b[N-2:0] : b[N-2:0];

    // Magnitude difference
    wire [N-2:0] mag_diff = a_abs - b_abs;

    // Result components
    wire res_sign = (a_sign == b_sign) ? 
                   (a_abs >= b_abs ? a_sign : ~a_sign) : 
                   a_sign;
                   
    wire [N-2:0] res_mag = (a_sign == b_sign) ? 
                          (a_abs >= b_abs ? mag_diff : -mag_diff) : 
                          (a_abs + b_abs);

    // Final result with zero handling
    assign c = (res_mag == 0) ? 0 : {res_sign, res_sign ? -res_mag : res_mag};

endmodule