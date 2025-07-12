module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Define inputs as an array for clarity
    wire inputs[4:0];
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Map (i,j) pairs to output bits from 24 down to 0 in row-major order
                assign out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule