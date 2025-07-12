module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    wire [7:0] ab_min = (a < b) ? a : b;
    wire [7:0] cd_min = (c < d) ? c : d;
    assign min = (ab_min < cd_min) ? ab_min : cd_min;

endmodule