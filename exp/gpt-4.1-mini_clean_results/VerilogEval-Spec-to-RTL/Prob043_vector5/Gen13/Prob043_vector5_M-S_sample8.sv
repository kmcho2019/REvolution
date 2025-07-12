module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec = {a, b, c, d, e};
    genvar i, j;

    generate
        for (i = 0; i < 5; i = i + 1) begin: gen_i
            for (j = 0; j < 5; j = j + 1) begin: gen_j
                // Calculate output bit index as per given ordering:
                // out[24 - (5*i + j)] corresponds to comparison between in_vec[4 - i] and in_vec[4 - j]
                assign out[24 - (5*i + j)] = in_vec[4 - i] ^~ in_vec[4 - j];
            end
        end
    endgenerate

endmodule