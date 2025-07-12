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
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Map bit index as out[24 - (i*5 + j)] = inputs[i] XNOR inputs[j]
                assign out[24 - (i * 5 + j)] = inputs[i] ^~ inputs[j];
            end
        end
    endgenerate
endmodule