module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    wire [4:0] inputs = {a,b,c,d,e};
    wire eq_bits[4:0][4:0]; // 2D array to hold comparisons

    genvar i, j;
    generate
        for (i=0; i<5; i=i+1) begin : row_loop
            for (j=0; j<5; j=j+1) begin : col_loop
                assign eq_bits[i][j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    // Flatten eq_bits into output vector in row-major order (i from 0 to 4, j from 0 to 4)
    assign out = {
        eq_bits[0][0], eq_bits[0][1], eq_bits[0][2], eq_bits[0][3], eq_bits[0][4],
        eq_bits[1][0], eq_bits[1][1], eq_bits[1][2], eq_bits[1][3], eq_bits[1][4],
        eq_bits[2][0], eq_bits[2][1], eq_bits[2][2], eq_bits[2][3], eq_bits[2][4],
        eq_bits[3][0], eq_bits[3][1], eq_bits[3][2], eq_bits[3][3], eq_bits[3][4],
        eq_bits[4][0], eq_bits[4][1], eq_bits[4][2], eq_bits[4][3], eq_bits[4][4]
    };
endmodule