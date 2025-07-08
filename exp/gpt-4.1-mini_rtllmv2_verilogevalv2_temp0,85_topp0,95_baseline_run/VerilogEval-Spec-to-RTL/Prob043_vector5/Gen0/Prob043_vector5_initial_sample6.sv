module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a,b,c,d,e};

    // Assign out bits from out[24] down to out[0]
    // Indexing: i = 0..4 for first input, j = 0..4 for second input
    // out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j])

    assign out = {
        ~(a ^ a), ~(a ^ b), ~(a ^ c), ~(a ^ d), ~(a ^ e),
        ~(b ^ a), ~(b ^ b), ~(b ^ c), ~(b ^ d), ~(b ^ e),
        ~(c ^ a), ~(c ^ b), ~(c ^ c), ~(c ^ d), ~(c ^ e),
        ~(d ^ a), ~(d ^ b), ~(d ^ c), ~(d ^ d), ~(d ^ e),
        ~(e ^ a), ~(e ^ b), ~(e ^ c), ~(e ^ d), ~(e ^ e)
    };

endmodule