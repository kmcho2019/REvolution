module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // First stage: Compare upper 4 bits in parallel
    wire [3:0] a_hi = a[7:4];
    wire [3:0] b_hi = b[7:4];
    wire [3:0] c_hi = c[7:4];
    wire [3:0] d_hi = d[7:4];
    
    wire ab_hi_lt = (a_hi < b_hi);
    wire cd_hi_lt = (c_hi < d_hi);
    
    // Second stage: Select potential mins based on upper bits
    wire [7:0] min_ab = ab_hi_lt ? a : (a_hi == b_hi && a[3:0] < b[3:0]) ? a : b;
    wire [7:0] min_cd = cd_hi_lt ? c : (c_hi == d_hi && c[3:0] < d[3:0]) ? c : d;
    
    // Third stage: Final comparison with early termination
    wire [3:0] min_ab_hi = min_ab[7:4];
    wire [3:0] min_cd_hi = min_cd[7:4];
    
    wire final_lt = (min_ab_hi < min_cd_hi);
    wire final_eq = (min_ab_hi == min_cd_hi);
    wire final_lo_lt = (min_ab[3:0] < min_cd[3:0]);
    
    assign min = final_lt ? min_ab : 
                (final_eq && final_lo_lt) ? min_ab : min_cd;

endmodule