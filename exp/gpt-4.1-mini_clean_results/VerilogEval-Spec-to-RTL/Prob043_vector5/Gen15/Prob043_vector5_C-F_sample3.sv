module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs into a 5-bit vector:
    // inputs[4] = a, inputs[3] = b, ..., inputs[0] = e
    wire [4:0] inputs = {a, b, c, d, e};

    // Function to map (i,j) input indices to output bit index
    // out[24] corresponds to inputs[0][0] = a vs a (i=0,j=0)
    // General mapping: out index = 24 - (5*i + j)
    // i,j in [0..4], inputs index from left (a=0) to right (e=4)
    function automatic int out_idx(input int i, input int j);
        begin
            out_idx = 24 - (5*i + j);
        end
    endfunction

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                localparam int idx = out_idx(i, j);
                if (i <= j) begin
                    // Compute upper triangle and diagonal directly with XNOR
                    assign out[idx] = inputs[4 - i] ~^ inputs[4 - j];
                end else begin
                    // For lower triangle, reuse symmetric bit to save logic and power
                    localparam int sym_idx = out_idx(j, i);
                    assign out[idx] = out[sym_idx];
                end
            end
        end
    endgenerate

endmodule