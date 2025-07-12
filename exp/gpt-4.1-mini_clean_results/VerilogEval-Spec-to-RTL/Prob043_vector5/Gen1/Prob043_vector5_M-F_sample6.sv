module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Reorder inputs so that inputs[4]=a, inputs[0]=e to match bit indexing
    wire [4:0] inputs = {e, d, c, b, a};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin: row
            for (j = 0; j < 5; j = j + 1) begin: col
                // Assign out bit with correct mapping:
                // bit index = (4 - i)*5 + (4 - j)
                assign out[(4 - i)*5 + (4 - j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate
endmodule