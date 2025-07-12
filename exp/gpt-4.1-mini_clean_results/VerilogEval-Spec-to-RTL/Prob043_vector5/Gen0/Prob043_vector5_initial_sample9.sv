module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Arrange inputs in an array for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};
    
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Calculate the index in out vector:
                // 5*i + j counts from 0 to 24, but we need to assign from out[24] down to out[0],
                // so assign bit at position 24 - (5*i + j)
                assign out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule