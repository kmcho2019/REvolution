module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Compute parity (sum bit 0)
    wire parity = in[0] ^ in[1] ^ in[2];
    // Compute carry (sum bit 1) as majority of the three inputs
    wire carry = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    assign out = {carry, parity};

endmodule