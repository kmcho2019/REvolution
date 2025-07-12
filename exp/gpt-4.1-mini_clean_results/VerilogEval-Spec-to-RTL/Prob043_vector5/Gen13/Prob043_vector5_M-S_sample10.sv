module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};
    genvar i, j;
    wire [24:0] temp_out;

    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Calculate index to place result in out vector:
                // out[24 - (i*5 + j)] = inputs[i] ~^ inputs[j]
                assign temp_out[24 - (i*5 + j)] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate

    assign out = temp_out;
endmodule