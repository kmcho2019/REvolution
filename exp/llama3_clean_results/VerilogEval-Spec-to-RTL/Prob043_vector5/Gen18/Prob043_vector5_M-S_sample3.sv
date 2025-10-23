module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    assign out[24] = (a == a) ? 1'b1 : 1'b0;
    assign out[23] = (a == b) ? 1'b1 : 1'b0;
    assign out[22] = (a == c) ? 1'b1 : 1'b0;
    assign out[21] = (a == d) ? 1'b1 : 1'b0;
    assign out[20] = (a == e) ? 1'b1 : 1'b0;
    assign out[19] = (b == a) ? 1'b1 : 1'b0;
    assign out[18] = (b == b) ? 1'b1 : 1'b0;
    assign out[17] = (b == c) ? 1'b1 : 1'b0;
    assign out[16] = (b == d) ? 1'b1 : 1'b0;
    assign out[15] = (b == e) ? 1'b1 : 1'b0;
    assign out[14] = (c == a) ? 1'b1 : 1'b0;
    assign out[13] = (c == b) ? 1'b1 : 1'b0;
    assign out[12] = (c == c) ? 1'b1 : 1'b0;
    assign out[11] = (c == d) ? 1'b1 : 1'b0;
    assign out[10] = (c == e) ? 1'b1 : 1'b0;
    assign out[9]  = (d == a) ? 1'b1 : 1'b0;
    assign out[8]  = (d == b) ? 1'b1 : 1'b0;
    assign out[7]  = (d == c) ? 1'b1 : 1'b0;
    assign out[6]  = (d == d) ? 1'b1 : 1'b0;
    assign out[5]  = (d == e) ? 1'b1 : 1'b0;
    assign out[4]  = (e == a) ? 1'b1 : 1'b0;
    assign out[3]  = (e == b) ? 1'b1 : 1'b0;
    assign out[2]  = (e == c) ? 1'b1 : 1'b0;
    assign out[1]  = (e == d) ? 1'b1 : 1'b0;
    assign out[0]  = (e == e) ? 1'b1 : 1'b0;

endmodule