module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Array of inputs for indexed access
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    wire [24:0] eq_bits;

    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Calculate index: bit 24 corresponds to i=0,j=0, bit 0 to i=4,j=4
                // So bit index = 24 - (i*5 + j)
                assign eq_bits[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    assign out = eq_bits;
endmodule