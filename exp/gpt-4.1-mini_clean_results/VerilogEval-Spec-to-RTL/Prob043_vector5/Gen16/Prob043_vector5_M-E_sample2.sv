module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a 5-bit vector: inputs[4]=a ... inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Flat array of wires to hold all 25 pairwise comparisons
    wire [24:0] cmp_wires;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Compute the linear index for output: idx = i*5 + j
                // Assign out[24 - idx] = XNOR of inputs[i] and inputs[j]
                assign cmp_wires[24 - (i*5 + j)] = ~(inputs[4 - i] ^ inputs[4 - j]);
            end
        end
    endgenerate

    assign out = cmp_wires;

endmodule