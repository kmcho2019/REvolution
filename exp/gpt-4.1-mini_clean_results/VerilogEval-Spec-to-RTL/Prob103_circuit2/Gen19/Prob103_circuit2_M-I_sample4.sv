module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire ab_xnor, cd_xnor;

// 2-input XNOR: ab_xnor = (a & b) | (~a & ~b)
assign ab_xnor = (a & b) | (~a & ~b);
assign cd_xnor = (c & d) | (~c & ~d);

// Final output q = XNOR of ab_xnor and cd_xnor
assign q = (ab_xnor & cd_xnor) | (~ab_xnor & ~cd_xnor);

endmodule