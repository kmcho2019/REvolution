module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire bit0 = in[0];
    wire bit1 = in[1];
    wire bit2 = in[2];

    wire one_set   = (bit0 ^ bit1) ^ bit2;                // odd parity: exactly 1 or 3 bits set
    wire two_set   = (bit0 & bit1) | (bit1 & bit2) | (bit0 & bit2); // any two bits set
    wire three_set = bit0 & bit1 & bit2;

    // Since maximum is 3, the outputs map as follows:
    // 0 bits set: 00
    // 1 bit set:  01
    // 2 bits set: 10
    // 3 bits set: 11
    assign out[1] = two_set | three_set;  // MSB is set if two or three bits set
    assign out[0] = (one_set & ~two_set); // LSB is set if exactly one bit is set

endmodule