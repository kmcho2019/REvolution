module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Calculate index from MSB = (0,0) to LSB = (4,4)
                // out[24 - (i*5 + j)] = equality of inputs[i] and inputs[j]
                assign out[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate
endmodule