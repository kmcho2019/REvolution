module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // out[0]: parity (XOR of all bits)
    wire parity = in[0] ^ in[1] ^ in[2];

    // out[1]: majority (at least two bits set)
    wire majority = (in[0] & in[1]) | (in[1] & in[2]) | (in[2] & in[0]);

    assign out = {majority, parity};

endmodule