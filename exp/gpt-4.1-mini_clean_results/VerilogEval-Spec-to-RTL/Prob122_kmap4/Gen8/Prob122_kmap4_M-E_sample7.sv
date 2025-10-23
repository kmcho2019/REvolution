module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire sel0, sel1, sel2, sel3;

    // Define the outputs for each combination of c and d:
    // For cd=00 -> out = 0
    // cd=01 -> out = 1
    // cd=11 -> out = 0
    // cd=10 -> out = 1

    // Multiplexer level 1: select based on d
    assign sel0 = (c == 1'b0) ? 1'b0 : 1'b1;  // For cd=00 or 01
    assign sel1 = (c == 1'b0) ? 1'b1 : 1'b0;  // For cd=10 or 11

    // Multiplexer level 2: select based on c,d
    wire cd_val0 = (d == 1'b0) ? sel0 : sel1;
    wire cd_val1 = (d == 1'b0) ? sel1 : sel0;

    // Use inputs a and b to select output from cd_val0 and cd_val1 to match K-map
    // The pattern alternates every column and row, which can be captured by a^b controlling the selection
    assign out = (a ^ b) ? cd_val1 : cd_val0;

endmodule