module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Pack inputs into a vector: idx 0->a, 1->b, 2->c, 3->d, 4->e
    wire [4:0] inputs = {a, b, c, d, e};
    
    genvar i, j;
    // Intermediate wire for each comparison (i,j)
    wire [4:0] eq_row [4:0];  // 5 rows each 5 bits
    
    generate
        for (i = 0; i < 5; i = i + 1) begin : ROWS
            for (j = 0; j < 5; j = j + 1) begin : COLS
                // equality using XNOR (~^)
                assign eq_row[i][4 - j] = inputs[i] ~^ inputs[j];
                // Note: 4-j so MSB corresponds to j=0, LSB j=4 in each row to match desired order
            end
        end
    endgenerate

    // Concatenate rows in order a,b,c,d,e to match out[24:0]
    assign out = {eq_row[0], eq_row[1], eq_row[2], eq_row[3], eq_row[4]};
endmodule