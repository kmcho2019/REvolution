module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec = {a, b, c, d, e};
    assign out = {
        in_vec[4] ^~ in_vec[4], in_vec[4] ^~ in_vec[3], in_vec[4] ^~ in_vec[2], in_vec[4] ^~ in_vec[1], in_vec[4] ^~ in_vec[0],
        in_vec[3] ^~ in_vec[4], in_vec[3] ^~ in_vec[3], in_vec[3] ^~ in_vec[2], in_vec[3] ^~ in_vec[1], in_vec[3] ^~ in_vec[0],
        in_vec[2] ^~ in_vec[4], in_vec[2] ^~ in_vec[3], in_vec[2] ^~ in_vec[2], in_vec[2] ^~ in_vec[1], in_vec[2] ^~ in_vec[0],
        in_vec[1] ^~ in_vec[4], in_vec[1] ^~ in_vec[3], in_vec[1] ^~ in_vec[2], in_vec[1] ^~ in_vec[1], in_vec[1] ^~ in_vec[0],
        in_vec[0] ^~ in_vec[4], in_vec[0] ^~ in_vec[3], in_vec[0] ^~ in_vec[2], in_vec[0] ^~ in_vec[1], in_vec[0] ^~ in_vec[0]
    };
endmodule