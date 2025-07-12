module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire ab_xnor, cd_xnor;
    assign ab_xnor = a ^~ b;
    assign cd_xnor = c ^~ d;
    assign q = ab_xnor ^~ cd_xnor;
endmodule