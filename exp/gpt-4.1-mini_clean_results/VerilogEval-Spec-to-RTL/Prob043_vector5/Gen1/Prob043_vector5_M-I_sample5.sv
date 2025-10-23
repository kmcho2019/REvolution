module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a,b,c,d,e};
    genvar i, j;

    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Assign each bit according to problem specification:
                // bit index = 24 - (row*5 + col)
                assign out[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]); // XNOR
            end
        end
    endgenerate

endmodule