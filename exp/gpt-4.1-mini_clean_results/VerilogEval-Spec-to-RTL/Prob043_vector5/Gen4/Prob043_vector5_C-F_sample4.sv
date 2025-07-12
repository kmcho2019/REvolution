module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Inputs arranged in natural order: 0:a, 1:b, 2:c, 3:d, 4:e
    wire inputs[4:0];
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Map pairs (i,j) to out bits in row-major order descending from 24 down to 0:
                // out[24] = compare a,a (inputs[0], inputs[0])
                // out[23] = compare a,b (inputs[0], inputs[1]), etc.
                assign out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule