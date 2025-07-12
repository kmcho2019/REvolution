module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    wire bit0 = in[0];
    wire bit1 = in[1];
    wire bit2 = in[2];

    // sum of bits: out[0] = parity (odd number of 1s)
    // out[1] = 1 if two or more bits are set
    assign out[0] = bit0 ^ bit1 ^ bit2;
    assign out[1] = (bit0 & bit1) | (bit1 & bit2) | (bit0 & bit2);

endmodule