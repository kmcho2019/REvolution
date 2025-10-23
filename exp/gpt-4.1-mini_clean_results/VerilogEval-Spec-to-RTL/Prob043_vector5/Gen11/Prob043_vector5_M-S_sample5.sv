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
        for (i = 0; i < 5; i = i + 1) begin : loop_i
            for (j = 0; j < 5; j = j + 1) begin : loop_j
                // Mapping output index: out[24 - (i*5 + j)] corresponds to in_vec[i] XNOR in_vec[j]
                assign out[24 - (i*5 + j)] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    endgenerate
endmodule