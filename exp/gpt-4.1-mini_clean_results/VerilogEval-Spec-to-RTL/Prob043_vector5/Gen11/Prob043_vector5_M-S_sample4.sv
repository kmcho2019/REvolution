module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Map out[24:0] = XNOR comparisons of inputs in the order given by problem:
    // out[24] = ~(a ^ a) = 1, out[23] = ~(a ^ b), ..., out[0] = ~(e ^ e) = 1
    assign out = {
        a ^~ a, a ^~ b, a ^~ c, a ^~ d, a ^~ e,
        b ^~ a, b ^~ b, b ^~ c, b ^~ d, b ^~ e,
        c ^~ a, c ^~ b, c ^~ c, c ^~ d, c ^~ e,
        d ^~ a, d ^~ b, d ^~ c, d ^~ d, d ^~ e,
        e ^~ a, e ^~ b, e ^~ c, e ^~ d, e ^~ e
    };

endmodule