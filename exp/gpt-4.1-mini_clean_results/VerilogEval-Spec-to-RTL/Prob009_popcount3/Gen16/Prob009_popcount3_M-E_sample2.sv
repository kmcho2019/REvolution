module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire bit0_set = in[0];
    wire bit1_set = in[1];
    wire bit2_set = in[2];

    // partial sum of first two bits
    wire sum01_bit0 = bit0_set ^ bit1_set;    // bit0 of sum for bits 0 and 1
    wire sum01_bit1 = bit0_set & bit1_set;    // carry bit (bit1) of sum for bits 0 and 1

    // add bit2 to partial sum (sum01)
    wire out_bit0 = sum01_bit0 ^ bit2_set;
    wire out_bit1 = sum01_bit1 | (sum01_bit0 & bit2_set);

    assign out = {out_bit1, out_bit0};

endmodule