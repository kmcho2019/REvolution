module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs as inputs[0]=a, inputs[1]=b, ..., inputs[4]=e for natural indexing
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Index output bits as per specification
                localparam int out_idx = 24 - (i*5 + j);
                // Compute equality directly with XNOR
                assign out[out_idx] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule