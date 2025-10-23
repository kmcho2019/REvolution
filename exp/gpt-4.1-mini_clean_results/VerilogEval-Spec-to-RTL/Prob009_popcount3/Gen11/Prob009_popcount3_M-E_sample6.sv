module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    wire bit0 = in[0];
    wire bit1 = in[1];
    wire bit2 = in[2];

    // sum_bit0: least significant bit of count: parity of all bits
    wire sum_bit0 = bit0 ^ bit1 ^ bit2;

    // sum_bit1: most significant bit of count: 1 if two or more bits are set
    wire sum_bit1 = (bit0 & bit1) | (bit1 & bit2) | (bit0 & bit2);

    assign out = {sum_bit1, sum_bit0};

endmodule