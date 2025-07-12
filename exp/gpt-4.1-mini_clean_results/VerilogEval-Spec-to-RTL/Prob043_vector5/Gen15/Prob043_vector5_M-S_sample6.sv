module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec = {a, b, c, d, e};
    genvar idx;
    generate
        for (idx = 0; idx < 25; idx = idx + 1) begin : gen_compare
            // row = idx / 5, col = idx % 5
            // out[24 - idx] compares in_vec[4 - row] and in_vec[4 - col]
            assign out[24 - idx] = in_vec[4 - (idx / 5)] ^~ in_vec[4 - (idx % 5)];
        end
    endgenerate
endmodule