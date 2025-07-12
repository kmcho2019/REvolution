module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // First level of comparisons
    wire [7:0] min_ab, min_cd;
    assign min_ab = (a < b)? a : b;
    assign min_cd = (c < d)? c : d;

    // Second level of comparisons
    wire [7:0] min_abc, min_abd, min_acd, min_bcd;
    assign min_abc = (min_ab < c)? min_ab : c;
    assign min_abd = (min_ab < d)? min_ab : d;
    assign min_acd = (a < min_cd)? a : min_cd;
    assign min_bcd = (b < min_cd)? b : min_cd;

    // Final level of comparison
    wire [7:0] min_abcd;
    assign min_abcd = (min_abc < min_abd)? (min_abc < min_acd)? min_abc : min_acd : (min_abd < min_acd)? min_abd : min_acd;

    // Assign the final minimum value to the output
    assign min = (min_abcd < min_bcd)? min_abcd : min_bcd;

endmodule