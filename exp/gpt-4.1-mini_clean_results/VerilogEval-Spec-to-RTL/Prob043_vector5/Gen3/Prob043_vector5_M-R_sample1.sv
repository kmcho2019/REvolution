module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Arrange inputs in order so inputs_array[0]=a, ..., inputs_array[4]=e
    wire [4:0] inputs_array;
    assign inputs_array[0] = a;
    assign inputs_array[1] = b;
    assign inputs_array[2] = c;
    assign inputs_array[3] = d;
    assign inputs_array[4] = e;

    // 5x5 matrix of pairwise equality (1 if equal, 0 if not)
    wire eq_matrix[0:4][0:4];
    genvar i, j;

    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                if (i == j) begin
                    // Same bit comparison always 1
                    assign eq_matrix[i][j] = 1'b1;
                end else begin
                    // XNOR for equality check
                    assign eq_matrix[i][j] = ~(inputs_array[i] ^ inputs_array[j]);
                end
            end
        end
    endgenerate

    // Flatten eq_matrix into out[24:0]
    // Mapping: out[24 - (i*5 + j)] = eq_matrix[i][j]
    // i,j in [0..4], so bits from 24 down to 0
    generate
        for (i = 0; i < 5; i = i + 1) begin : map_i
            for (j = 0; j < 5; j = j + 1) begin : map_j
                localparam int idx = 24 - (i * 5 + j);
                assign out[idx] = eq_matrix[i][j];
            end
        end
    endgenerate

endmodule