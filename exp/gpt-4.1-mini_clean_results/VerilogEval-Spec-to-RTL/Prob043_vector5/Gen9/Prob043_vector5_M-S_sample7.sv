module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    wire [4:0] in_vec = {a, b, c, d, e};
    genvar i, j;

    generate
        for (i = 0; i < 5; i = i + 1) begin: outer
            for (j = 0; j < 5; j = j + 1) begin: inner
                assign out[5*(4 - i) + (4 - j)] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    endgenerate

endmodule