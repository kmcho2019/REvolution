module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Inputs named for clarity
    // Output bits indexed as per problem statement:
    // out[24] = (a == a)
    // out[23] = (a == b)
    // ...
    // out[0]  = (e == e)

    assign out = {
        ~(a ^ a), ~(a ^ b), ~(a ^ c), ~(a ^ d), ~(a ^ e),  // bits 24 down to 20
        ~(b ^ a), ~(b ^ b), ~(b ^ c), ~(b ^ d), ~(b ^ e),  // bits 19 down to 15
        ~(c ^ a), ~(c ^ b), ~(c ^ c), ~(c ^ d), ~(c ^ e),  // bits 14 down to 10
        ~(d ^ a), ~(d ^ b), ~(d ^ c), ~(d ^ d), ~(d ^ e),  // bits 9 down to 5
        ~(e ^ a), ~(e ^ b), ~(e ^ c), ~(e ^ d), ~(e ^ e)   // bits 4 down to 0
    };

endmodule