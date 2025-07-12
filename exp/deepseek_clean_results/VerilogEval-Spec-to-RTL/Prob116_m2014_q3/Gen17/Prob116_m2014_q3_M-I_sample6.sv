module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output f
);
    // Optimized NAND-only implementation using only 2-input gates
    wire term1 = ~(~x[0] & x[2]);
    wire term2_part1 = ~(x[0] & x[1]);
    wire term2_part2 = ~(term2_part1 & x[3]);
    assign f = ~(term1 & term2_part2);
endmodule