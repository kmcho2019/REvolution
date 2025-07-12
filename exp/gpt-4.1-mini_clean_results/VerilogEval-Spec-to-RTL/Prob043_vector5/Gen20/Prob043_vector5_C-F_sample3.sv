module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs as inputs[0]=a, inputs[1]=b, ..., inputs[4]=e
    wire [4:0] inputs = {e, d, c, b, a}; // reversed to align inputs[i] with index i

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                localparam int idx = 24 - (i*5 + j);
                if (i <= j) begin
                    // Upper triangle including diagonal: compute equality with XNOR
                    assign out[idx] = ~(inputs[i] ^ inputs[j]);
                end else begin
                    // Lower triangle: reuse corresponding upper triangle output bit
                    localparam int mirror_idx = 24 - (j*5 + i);
                    assign out[idx] = out[mirror_idx];
                end
            end
        end
    endgenerate
endmodule