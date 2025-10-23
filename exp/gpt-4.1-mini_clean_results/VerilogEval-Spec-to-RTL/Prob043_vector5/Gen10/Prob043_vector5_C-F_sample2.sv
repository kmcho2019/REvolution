module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector: inputs[4]=a ... inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Calculate bit index in output vector
                localparam int idx = 24 - (5*i + j);
                if (i <= j) begin
                    // Compute equality directly with XNOR for upper triangle and diagonal
                    assign out[idx] = inputs[4 - i] ~^ inputs[4 - j];
                end else begin
                    // For lower triangle, assign symmetric bit to reuse logic and reduce area/power
                    localparam int sym_idx = 24 - (5*j + i);
                    assign out[idx] = out[sym_idx];
                end
            end
        end
    endgenerate
endmodule