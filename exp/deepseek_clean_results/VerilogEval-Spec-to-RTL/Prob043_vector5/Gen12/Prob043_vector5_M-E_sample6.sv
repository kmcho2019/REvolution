module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);
    // Create vectors for comparison
    wire [4:0] row_vec = {5{a}} | {5{b}} | {5{c}} | {5{d}} | {5{e}};
    wire [4:0] col_vec = {a,b,c,d,e};
    
    // Generate all 25 comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_gen
            for (j = 0; j < 5; j = j + 1) begin : col_gen
                assign out[24 - (i*5 + j)] = ~(row_vec[i] ^ col_vec[j]);
            end
        end
    endgenerate
endmodule