module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs as {a,b,c,d,e} with inputs[0]=a, ..., inputs[4]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Function to calculate output bit index based on (i,j)
    // Map so out[24 - (5*i + j)] corresponds to inputs[i] XNOR inputs[j],
    // with i,j in [0..4], inputs[0]=a, inputs[4]=e
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
                // Directly compute equality using XNOR for all pairs
                assign out[idx] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate

endmodule