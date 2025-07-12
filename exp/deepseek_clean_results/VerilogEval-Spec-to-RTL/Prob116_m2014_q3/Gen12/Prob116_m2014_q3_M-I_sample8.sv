module TopModule(
    input [3:0] x,
    output f
);
    // Further optimized implementation
    assign f = (~x[0] & x[2]) | (x[0] & x[1]);
endmodule