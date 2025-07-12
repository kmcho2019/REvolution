module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output f
);
    // NAND-only implementation which might be more area-efficient in CMOS
    wire term1 = ~(~x[0] & x[2]);
    wire term2 = ~(x[0] & x[1] & x[3]);
    assign f = ~(term1 & term2);
endmodule