module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // First level optimized comparisons
    wire ab_lt = (a < b);
    wire cd_lt = (c < d);
    
    wire [7:0] min_ab = ab_lt ? a : b;
    wire [7:0] min_cd = cd_lt ? c : d;
    
    // Final optimized comparison
    wire final_lt = (min_ab < min_cd);
    assign min = final_lt ? min_ab : min_cd;

endmodule