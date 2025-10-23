module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec;
    assign in_vec = {a, b, c, d, e};

    assign out[24] = ~(in_vec[4] ^ in_vec[4]); // a == a
    assign out[23] = ~(in_vec[4] ^ in_vec[3]); // a == b
    assign out[22] = ~(in_vec[4] ^ in_vec[2]); // a == c
    assign out[21] = ~(in_vec[4] ^ in_vec[1]); // a == d
    assign out[20] = ~(in_vec[4] ^ in_vec[0]); // a == e

    assign out[19] = ~(in_vec[3] ^ in_vec[4]); // b == a
    assign out[18] = ~(in_vec[3] ^ in_vec[3]); // b == b
    assign out[17] = ~(in_vec[3] ^ in_vec[2]); // b == c
    assign out[16] = ~(in_vec[3] ^ in_vec[1]); // b == d
    assign out[15] = ~(in_vec[3] ^ in_vec[0]); // b == e

    assign out[14] = ~(in_vec[2] ^ in_vec[4]); // c == a
    assign out[13] = ~(in_vec[2] ^ in_vec[3]); // c == b
    assign out[12] = ~(in_vec[2] ^ in_vec[2]); // c == c
    assign out[11] = ~(in_vec[2] ^ in_vec[1]); // c == d
    assign out[10] = ~(in_vec[2] ^ in_vec[0]); // c == e

    assign out[9]  = ~(in_vec[1] ^ in_vec[4]); // d == a
    assign out[8]  = ~(in_vec[1] ^ in_vec[3]); // d == b
    assign out[7]  = ~(in_vec[1] ^ in_vec[2]); // d == c
    assign out[6]  = ~(in_vec[1] ^ in_vec[1]); // d == d
    assign out[5]  = ~(in_vec[1] ^ in_vec[0]); // d == e

    assign out[4]  = ~(in_vec[0] ^ in_vec[4]); // e == a
    assign out[3]  = ~(in_vec[0] ^ in_vec[3]); // e == b
    assign out[2]  = ~(in_vec[0] ^ in_vec[2]); // e == c
    assign out[1]  = ~(in_vec[0] ^ in_vec[1]); // e == d
    assign out[0]  = ~(in_vec[0] ^ in_vec[0]); // e == e
endmodule