module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Pack inputs into a vector with inputs[4]=a down to inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                localparam int idx = 24 - (5*i + j);
                if (i <= j) begin
                    // Compute equality with XNOR for upper triangle and diagonal
                    assign out[idx] = inputs[4 - i] ~^ inputs[4 - j];
                end else begin
                    // Reuse symmetric bit to reduce logic duplication for lower triangle
                    localparam int sym_idx = 24 - (5*j + i);
                    assign out[idx] = out[sym_idx];
                end
            end
        end
    endgenerate
endmodule