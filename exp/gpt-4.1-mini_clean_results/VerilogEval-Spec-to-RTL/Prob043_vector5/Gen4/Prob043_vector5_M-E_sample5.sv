module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Pack inputs into a 5-bit vector for indexed access: inputs[4]=e, inputs[3]=d, ..., inputs[0]=a
    wire [4:0] inputs = {e, d, c, b, a};

    genvar i, j;
    generate
        for (j = 0; j < 5; j = j + 1) begin : col_loop
            for (i = 0; i < 5; i = i + 1) begin : row_loop
                // Assign out bits in column-major order: out[5*j + i] = equality(inputs[i], inputs[j])
                assign out[5*j + i] = ~(inputs[i] ^ inputs[j]); // XNOR for equality
            end
        end
    endgenerate

endmodule