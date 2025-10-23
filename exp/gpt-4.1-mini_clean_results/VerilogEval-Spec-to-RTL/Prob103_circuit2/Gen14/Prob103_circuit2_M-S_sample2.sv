module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Directly assign XNOR of all inputs using reduction XNOR operator
    assign q = a ^~ b ^~ c ^~ d;

endmodule