module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs as {a,b,c,d,e} with inputs[4]=a ... inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Function to calculate output bit index based on (i,j)
    // Mapping: out[24 - (5*i + j)] corresponds to comparison inputs[i], inputs[j]
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
                    // Compute equality for upper triangle and diagonal
                    assign out[idx] = inputs[4 - i] ~^ inputs[4 - j];
                end else begin
                    // Reuse symmetric bit for lower triangle to save logic
                    localparam int sym_idx = out_idx(j, i);
                    assign out[idx] = out[sym_idx];
                end
            end
        end
    endgenerate

endmodule