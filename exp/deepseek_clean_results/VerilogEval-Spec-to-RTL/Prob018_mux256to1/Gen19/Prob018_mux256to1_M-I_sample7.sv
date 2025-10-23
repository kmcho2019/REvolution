module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Implement as binary tree with 8 levels
    wire [255:0] stage [0:7];
    assign stage[0] = in;
    
    genvar i, j;
    generate
        for (i = 1; i <= 7; i = i + 1) begin : tree_level
            for (j = 0; j < (256 >> i); j = j + 1) begin : mux2
                assign stage[i][j] = sel[i-1] ? stage[i-1][2*j+1] : stage[i-1][2*j];
            end
        end
    endgenerate
    
    assign out = stage[7][0];

endmodule