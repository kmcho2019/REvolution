module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a,b,c,d,e};

    // Mapping: out[24 - (5*i + j)] = inputs[i] XNOR inputs[j]
    // So out[24] corresponds to i=0,j=0; out[0] corresponds to i=4,j=4
    assign out = {
        ~(a ^ a), ~(a ^ b), ~(a ^ c), ~(a ^ d), ~(a ^ e),
        ~(b ^ a), ~(b ^ b), ~(b ^ c), ~(b ^ d), ~(b ^ e),
        ~(c ^ a), ~(c ^ b), ~(c ^ c), ~(c ^ d), ~(c ^ e),
        ~(d ^ a), ~(d ^ b), ~(d ^ c), ~(d ^ d), ~(d ^ e),
        ~(e ^ a), ~(e ^ b), ~(e ^ c), ~(e ^ d), ~(e ^ e)
    };

endmodule