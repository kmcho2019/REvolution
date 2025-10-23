module fixed_point_subtractor #(
    parameter N = 32,
    parameter Q = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude conversion (two's complement to absolute value)
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];
    
    // Result sign and magnitude calculation
    wire same_sign = (a_sign == b_sign);
    wire a_larger = (a_mag >= b_mag);
    
    wire [N-2:0] sub_mag = same_sign ? 
                          (a_larger ? a_mag - b_mag : b_mag - a_mag) : 
                          a_mag + b_mag;
    
    wire res_sign = same_sign ? 
                   (a_larger ? a_sign : ~a_sign) : 
                   a_sign;
    
    // Result reconstruction (sign-magnitude to two's complement)
    wire [N-2:0] final_mag = (sub_mag == 0) ? 0 : 
                            (res_sign ? ~sub_mag + 1'b1 : sub_mag);
    
    assign c = {res_sign, final_mag};

endmodule