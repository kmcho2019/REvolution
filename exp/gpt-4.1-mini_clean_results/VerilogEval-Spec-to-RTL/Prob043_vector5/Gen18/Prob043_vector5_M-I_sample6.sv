module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into an array for convenient indexing:
    // inputs[4] = a, inputs[3] = b, ..., inputs[0] = e
    wire [4:0] inputs = {a, b, c, d, e};

    // Declare a 2D wire array to hold the unique upper-triangle plus diagonal results
    // eq[i][j] valid only for j >= i
    wire eq [4:0][4:0];

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i +1) begin : row_loop
            for (j = i; j < 5; j = j +1) begin : col_loop
                assign eq[i][j] = ~(inputs[i] ^ inputs[j]);  // XNOR
            end
        end
    endgenerate

    // Now map the 25 output bits in the prescribed order:
    // out[24] = inputs[4] ~^ inputs[4]
    // out[23] = inputs[4] ~^ inputs[3]
    // ...
    // out[0]  = inputs[0] ~^ inputs[0]
    //
    // Mapping bits:
    // out[bit_index] = inputs[row] ~^ inputs[col]
    // where row = 4 - (bit_index / 5), col = 4 - (bit_index % 5)
    //
    // For pairs with col >= row, out = eq[row][col]
    // else out = eq[col][row] (mirror)

    generate
        for (int bit_idx = 0; bit_idx < 25; bit_idx = bit_idx + 1) begin : out_bits
            // Calculate row and col indices
            // Note: integer division truncates in Verilog-2001 and above
            localparam int row = 4 - (bit_idx / 5);
            localparam int col = 4 - (bit_idx % 5);

            // Assign output bit considering symmetry
            assign out[24 - bit_idx] = (col >= row) ? eq[row][col] : eq[col][row];
        end
    endgenerate

endmodule