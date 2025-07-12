module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Reorder inputs so inputs[4]=a, inputs[0]=e to match output bit mapping
    wire [4:0] inputs = {e, d, c, b, a};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                localparam integer bit_index = (4 - i)*5 + (4 - j);
                assign out[bit_index] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate
endmodule