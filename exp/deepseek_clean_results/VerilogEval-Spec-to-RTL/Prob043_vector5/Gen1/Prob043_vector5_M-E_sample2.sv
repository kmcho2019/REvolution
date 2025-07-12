module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Precompute complements
    wire na, nb, nc, nd, ne;
    assign na = ~a;
    assign nb = ~b;
    assign nc = ~c;
    assign nd = ~d;
    assign ne = ~e;

    // Define comparison order matrix
    localparam [2:0] COMP_MATRIX [0:4][0:4] = '{
        '{3'd0, 3'd1, 3'd2, 3'd3, 3'd4},  // a vs a,b,c,d,e
        '{3'd1, 3'd0, 3'd2, 3'd3, 3'd4},  // b vs a,b,c,d,e
        '{3'd2, 3'd1, 3'd0, 3'd3, 3'd4},  // c vs a,b,c,d,e
        '{3'd3, 3'd1, 3'd2, 3'd0, 3'd4},  // d vs a,b,c,d,e
        '{3'd4, 3'd1, 3'd2, 3'd3, 3'd0}   // e vs a,b,c,d,e
    };

    // Input array for easy indexing
    wire [4:0] inputs = {e, d, c, b, a};
    wire [4:0] ninputs = {ne, nd, nc, nb, na};

    // Generate all comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // out[24:0] maps to [4,4]...[0,0] in matrix
                assign out[24 - (i*5 + j)] = 
                    ~(inputs[COMP_MATRIX[i][j]] ^ ninputs[4-i]);
            end
        end
    endgenerate

endmodule