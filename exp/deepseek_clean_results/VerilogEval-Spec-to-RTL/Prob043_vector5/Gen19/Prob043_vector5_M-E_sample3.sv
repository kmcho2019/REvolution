module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);
    // Original input vector
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Create row-wise and column-wise replicated matrices
    wire [24:0] row_matrix = {5{inputs}};
    wire [24:0] col_matrix = { {5{a}}, {5{b}}, {5{c}}, {5{d}}, {5{e}} };
    
    // Perform bulk comparison (will have 1's on diagonal)
    wire [24:0] comp_matrix = row_matrix ~^ col_matrix;
    
    // Manually set diagonal bits to 1 (every 6th bit starting from 0)
    assign out = comp_matrix | 25'b1_00001_00001_00001_00001;
endmodule