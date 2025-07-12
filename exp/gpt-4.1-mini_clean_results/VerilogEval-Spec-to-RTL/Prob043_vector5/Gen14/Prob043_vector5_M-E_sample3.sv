module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs as {e,d,c,b,a} to simplify indexing: inputs[4] = a, inputs[0] = e
    wire [4:0] inputs = {e, d, c, b, a};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Calculate output bit index: out[24 - (5*i + j)]
                localparam int idx = 24 - (5*i + j);
                // Assign XNOR of inputs[i] and inputs[j]
                assign out[idx] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate

endmodule