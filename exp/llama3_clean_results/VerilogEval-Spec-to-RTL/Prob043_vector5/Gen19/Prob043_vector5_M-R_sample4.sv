// Define a small, reusable vector comparator module
module VectorComparator(
    input  [4:0] vec1,
    input  [4:0] vec2,
    output [24:0] out
);

    assign out[24] = ~(vec1[0] ^ vec1[0]);
    assign out[23] = ~(vec1[0] ^ vec1[1]);
    assign out[22] = ~(vec1[0] ^ vec1[2]);
    assign out[21] = ~(vec1[0] ^ vec1[3]);
    assign out[20] = ~(vec1[0] ^ vec1[4]);
    assign out[19] = ~(vec1[1] ^ vec1[0]);
    assign out[18] = ~(vec1[1] ^ vec1[1]);
    assign out[17] = ~(vec1[1] ^ vec1[2]);
    assign out[16] = ~(vec1[1] ^ vec1[3]);
    assign out[15] = ~(vec1[1] ^ vec1[4]);
    assign out[14] = ~(vec1[2] ^ vec1[0]);
    assign out[13] = ~(vec1[2] ^ vec1[1]);
    assign out[12] = ~(vec1[2] ^ vec1[2]);
    assign out[11] = ~(vec1[2] ^ vec1[3]);
    assign out[10] = ~(vec1[2] ^ vec1[4]);
    assign out[9]  = ~(vec1[3] ^ vec1[0]);
    assign out[8]  = ~(vec1[3] ^ vec1[1]);
    assign out[7]  = ~(vec1[3] ^ vec1[2]);
    assign out[6]  = ~(vec1[3] ^ vec1[3]);
    assign out[5]  = ~(vec1[3] ^ vec1[4]);
    assign out[4]  = ~(vec1[4] ^ vec1[0]);
    assign out[3]  = ~(vec1[4] ^ vec1[1]);
    assign out[2]  = ~(vec1[4] ^ vec1[2]);
    assign out[1]  = ~(vec1[4] ^ vec1[3]);
    assign out[0]  = ~(vec1[4] ^ vec1[4]);

endmodule

// TopModule utilizing the VectorComparator module
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Directly assigning inputs to the VectorComparator module
    VectorComparator cmp({a, b, c, d, e}, {a, b, c, d, e}, out);

endmodule