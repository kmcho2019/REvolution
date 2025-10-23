module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Bit mapping:
    // out[24 - (5*i + j)] = (inputs[i] == inputs[j])
    // i, j from 0 to 4, with i being row, j being column.
    // But the problem's example seems to start from a==a at out[24], so bit position = 24 - (5*i + j)
    
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                assign out[24 - (5*i + j)] = (inputs[i] == inputs[j]);
            end
        end
    endgenerate
endmodule