module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Implementing the K-map pattern: output is 1 when parity of inputs is odd
    // K-map pattern:
    //           ab
    //    cd   00 01 11 10
    //    00 | 0 | 1 | 0 | 1 |
    //    01 | 1 | 0 | 1 | 0 |
    //    11 | 0 | 1 | 0 | 1 |
    //    10 | 1 | 0 | 1 | 0 |
    //
    // This corresponds to odd parity of inputs a,b,c,d:
    // out = (a ^ b) ^ (c ^ d)

    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;
    assign out = ab_xor ^ cd_xor;
endmodule