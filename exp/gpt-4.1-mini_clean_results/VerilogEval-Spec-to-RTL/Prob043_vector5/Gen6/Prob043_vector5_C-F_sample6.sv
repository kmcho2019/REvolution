module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Put inputs in an array for scalable indexing
    wire [4:0] in_arr = {a, b, c, d, e};

    // The outputs are indexed as:
    // out[24] = (a == a), out[23] = (a == b), ..., out[20] = (a == e)
    // out[19] = (b == a), ..., out[0] = (e == e)
    //
    // Index formula:
    // out index = 24 - (row*5 + col), where row and col in [0..4]
    // row = i-th input (0 = a), col = j-th input (0 = a)

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : ROWS
            for (j = 0; j < 5; j = j + 1) begin : COLS
                localparam int bit_idx = 24 - (i*5 + j);
                // Diagonal elements (self-comparisons) always 1
                if (i == j) begin
                    assign out[bit_idx] = 1'b1;
                end else begin
                    // Use XNOR (~^) for equality test
                    assign out[bit_idx] = in_arr[i] ~^ in_arr[j];
                end
            end
        end
    endgenerate

endmodule