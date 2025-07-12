module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Input vector for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Generate all 25 comparisons (5x5 matrix)
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Diagonal elements (self-comparisons) are always 1
                if (i == j) begin
                    assign out[24 - (i*5 + j)] = 1'b1;
                end else begin
                    assign out[24 - (i*5 + j)] = inputs[i] ~^ inputs[j];
                end
            end
        end
    endgenerate

    /* Equivalent to this explicit mapping:
    assign out[24:20] = {1'b1,       a ~^ b, a ~^ c, a ~^ d, a ~^ e};
    assign out[19:15] = {b ~^ a,      1'b1,  b ~^ c, b ~^ d, b ~^ e};
    assign out[14:10] = {c ~^ a,     c ~^ b,  1'b1,  c ~^ d, c ~^ e};
    assign out[ 9: 5] = {d ~^ a,     d ~^ b, d ~^ c,  1'b1,  d ~^ e};
    assign out[ 4: 0] = {e ~^ a,     e ~^ b, e ~^ c, e ~^ d,  1'b1 };
    */

endmodule