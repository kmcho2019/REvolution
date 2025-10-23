module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec = {a, b, c, d, e};

    assign out[24] = in_vec[4] ^~ in_vec[4]; // a vs a
    assign out[23] = in_vec[4] ^~ in_vec[3]; // a vs b
    assign out[22] = in_vec[4] ^~ in_vec[2]; // a vs c
    assign out[21] = in_vec[4] ^~ in_vec[1]; // a vs d
    assign out[20] = in_vec[4] ^~ in_vec[0]; // a vs e

    assign out[19] = in_vec[3] ^~ in_vec[4]; // b vs a
    assign out[18] = in_vec[3] ^~ in_vec[3]; // b vs b
    assign out[17] = in_vec[3] ^~ in_vec[2]; // b vs c
    assign out[16] = in_vec[3] ^~ in_vec[1]; // b vs d
    assign out[15] = in_vec[3] ^~ in_vec[0]; // b vs e

    assign out[14] = in_vec[2] ^~ in_vec[4]; // c vs a
    assign out[13] = in_vec[2] ^~ in_vec[3]; // c vs b
    assign out[12] = in_vec[2] ^~ in_vec[2]; // c vs c
    assign out[11] = in_vec[2] ^~ in_vec[1]; // c vs d
    assign out[10] = in_vec[2] ^~ in_vec[0]; // c vs e

    assign out[9]  = in_vec[1] ^~ in_vec[4]; // d vs a
    assign out[8]  = in_vec[1] ^~ in_vec[3]; // d vs b
    assign out[7]  = in_vec[1] ^~ in_vec[2]; // d vs c
    assign out[6]  = in_vec[1] ^~ in_vec[1]; // d vs d
    assign out[5]  = in_vec[1] ^~ in_vec[0]; // d vs e

    assign out[4]  = in_vec[0] ^~ in_vec[4]; // e vs a
    assign out[3]  = in_vec[0] ^~ in_vec[3]; // e vs b
    assign out[2]  = in_vec[0] ^~ in_vec[2]; // e vs c
    assign out[1]  = in_vec[0] ^~ in_vec[1]; // e vs d
    assign out[0]  = in_vec[0] ^~ in_vec[0]; // e vs e

endmodule