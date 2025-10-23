module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // Intermediate partial products for majority calculation
    wire and01 = in[0] & in[1];
    wire and12 = in[1] & in[2];
    wire and02 = in[0] & in[2];

    // out[0]: parity of input bits
    assign out[0] = in[0] ^ in[1] ^ in[2];
    // out[1]: majority (at least two ones)
    assign out[1] = and01 | and12 | and02;
endmodule