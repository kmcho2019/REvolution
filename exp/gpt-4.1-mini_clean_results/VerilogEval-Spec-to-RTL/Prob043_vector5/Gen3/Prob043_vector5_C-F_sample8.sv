module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Define inputs as an array for clarity, indexed as:
    // inputs[0] = a, inputs[1] = b, inputs[2] = c, inputs[3] = d, inputs[4] = e
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
                // Output bit indexing:
                // out[24] corresponds to inputs[0] == inputs[0] (a == a)
                // out[23] corresponds to inputs[0] == inputs[1] (a == b), etc.
                // Row-major order: out[24 - (5*i + j)] = equality of inputs[i], inputs[j]
                assign out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule