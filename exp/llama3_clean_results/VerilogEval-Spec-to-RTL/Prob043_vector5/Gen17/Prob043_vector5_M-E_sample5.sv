module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    reg [4:0][4:0] comparison_matrix;
    reg [24:0] temp_out;

    always @(a, b, c, d, e) begin
        // Initialize the comparison matrix
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                case ({i, j})
                    2'b00: comparison_matrix[i][j] = ~(a ^ a);
                    2'b01: comparison_matrix[i][j] = ~(a ^ b);
                    2'b02: comparison_matrix[i][j] = ~(a ^ c);
                    2'b03: comparison_matrix[i][j] = ~(a ^ d);
                    2'b04: comparison_matrix[i][j] = ~(a ^ e);
                    2'b10: comparison_matrix[i][j] = ~(b ^ a);
                    2'b11: comparison_matrix[i][j] = ~(b ^ b);
                    2'b12: comparison_matrix[i][j] = ~(b ^ c);
                    2'b13: comparison_matrix[i][j] = ~(b ^ d);
                    2'b14: comparison_matrix[i][j] = ~(b ^ e);
                    2'b20: comparison_matrix[i][j] = ~(c ^ a);
                    2'b21: comparison_matrix[i][j] = ~(c ^ b);
                    2'b22: comparison_matrix[i][j] = ~(c ^ c);
                    2'b23: comparison_matrix[i][j] = ~(c ^ d);
                    2'b24: comparison_matrix[i][j] = ~(c ^ e);
                    2'b30: comparison_matrix[i][j] = ~(d ^ a);
                    2'b31: comparison_matrix[i][j] = ~(d ^ b);
                    2'b32: comparison_matrix[i][j] = ~(d ^ c);
                    2'b33: comparison_matrix[i][j] = ~(d ^ d);
                    2'b34: comparison_matrix[i][j] = ~(d ^ e);
                    2'b40: comparison_matrix[i][j] = ~(e ^ a);
                    2'b41: comparison_matrix[i][j] = ~(e ^ b);
                    2'b42: comparison_matrix[i][j] = ~(e ^ c);
                    2'b43: comparison_matrix[i][j] = ~(e ^ d);
                    2'b44: comparison_matrix[i][j] = ~(e ^ e);
                    default: comparison_matrix[i][j] = 1'b0;
                endcase
            end
        end

        // Generate the output vector
        temp_out[24] = comparison_matrix[0][0];
        temp_out[23] = comparison_matrix[0][1];
        temp_out[22] = comparison_matrix[0][2];
        temp_out[21] = comparison_matrix[0][3];
        temp_out[20] = comparison_matrix[0][4];
        temp_out[19] = comparison_matrix[1][0];
        temp_out[18] = comparison_matrix[1][1];
        temp_out[17] = comparison_matrix[1][2];
        temp_out[16] = comparison_matrix[1][3];
        temp_out[15] = comparison_matrix[1][4];
        temp_out[14] = comparison_matrix[2][0];
        temp_out[13] = comparison_matrix[2][1];
        temp_out[12] = comparison_matrix[2][2];
        temp_out[11] = comparison_matrix[2][3];
        temp_out[10] = comparison_matrix[2][4];
        temp_out[9] = comparison_matrix[3][0];
        temp_out[8] = comparison_matrix[3][1];
        temp_out[7] = comparison_matrix[3][2];
        temp_out[6] = comparison_matrix[3][3];
        temp_out[5] = comparison_matrix[3][4];
        temp_out[4] = comparison_matrix[4][0];
        temp_out[3] = comparison_matrix[4][1];
        temp_out[2] = comparison_matrix[4][2];
        temp_out[1] = comparison_matrix[4][3];
        temp_out[0] = comparison_matrix[4][4];

        out = temp_out;
    end

endmodule