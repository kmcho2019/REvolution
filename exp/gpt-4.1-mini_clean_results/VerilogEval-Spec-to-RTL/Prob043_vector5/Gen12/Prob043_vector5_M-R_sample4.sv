module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a, b, c, d, e};
    wire [24:0] comp_bits;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Compute index in out vector as per specification:
                // index = 5*(4 - i) + (4 - j)
                // Because out[24] corresponds to (a,a), and goes down to out[0] for (e,e).
                assign comp_bits[5*(4 - i) + (4 - j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    assign out = comp_bits;

endmodule