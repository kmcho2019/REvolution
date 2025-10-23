module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs;
    assign inputs = {a, b, c, d, e};

    wire [24:0] out_intermediate;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer_loop
            for (j = 0; j < 5; j = j + 1) begin : inner_loop
                // Compute comparison with straightforward indexing:
                // out_intermediate[i*5 + j] = XNOR of inputs[i] and inputs[j]
                assign out_intermediate[i*5 + j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    // Reverse out_intermediate to produce out so that:
    // out[24] = out_intermediate[0], out[0] = out_intermediate[24]
    genvar k;
    generate
        for (k = 0; k < 25; k = k + 1) begin : reverse_loop
            assign out[24 - k] = out_intermediate[k];
        end
    endgenerate

endmodule