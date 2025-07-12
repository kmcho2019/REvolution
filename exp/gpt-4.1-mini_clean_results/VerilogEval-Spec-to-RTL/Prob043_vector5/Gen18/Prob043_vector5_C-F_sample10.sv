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

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Linear index for output bit: idx = i*5 + j
                // output bit = 24 - idx (per problem statement)
                localparam int out_idx = 24 - (i*5 + j);

                if (i <= j) begin : upper_triangle
                    // Compute equality directly with XNOR for upper triangle including diagonal
                    assign out[out_idx] = ~(inputs[4 - i] ^ inputs[4 - j]);
                end else begin : lower_triangle
                    // Reuse symmetric comparison result from out[24-(j*5 + i)]
                    localparam int sym_idx = 24 - (j*5 + i);
                    assign out[out_idx] = out[sym_idx];
                end
            end
        end
    endgenerate

endmodule