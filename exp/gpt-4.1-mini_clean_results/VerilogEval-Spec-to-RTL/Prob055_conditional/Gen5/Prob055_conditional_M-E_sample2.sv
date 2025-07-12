module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);
    // Compute the minimum using nested conditional operators
    // Compare a and b first
    wire [7:0] ab_min = (a < b) ? a : b;
    // Compare c and d
    wire [7:0] cd_min = (c < d) ? c : d;
    // Compare the two intermediate minimums
    assign min = (ab_min < cd_min) ? ab_min : cd_min;

endmodule