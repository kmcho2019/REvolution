module TopModule (
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
        // output bits indexed from 24 down to 0
        // out[24] = ~(a ^ a), ..., out[0] = ~(e ^ e)
        // Mapping: idx = 5*(4 - i) + (4 - j)
        for (i = 4; i >= 0; i = i - 1) begin : gen_i
            for (j = 4; j >= 0; j = j - 1) begin : gen_j
                localparam int idx = 5 * (4 - i) + (4 - j);
                assign out[idx] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    endgenerate
endmodule