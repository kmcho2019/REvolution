module TopModule (
    input  [99:0] in,
    output reg   out_and,
    output reg   out_or,
    output reg   out_xor
);

    integer i, level_size;
    reg [99:0] and_stage [0:6];
    reg [99:0] or_stage  [0:6];
    reg [99:0] xor_stage [0:6];

    always @* begin
        // Initialize level 0 with inputs
        for (i = 0; i < 100; i = i + 1) begin
            and_stage[0][i] = in[i];
            or_stage[0][i]  = in[i];
            xor_stage[0][i] = in[i];
        end

        level_size = 100;
        // Build balanced trees for AND, OR, XOR reductions
        for (int level = 1; level <= 6; level = level + 1) begin
            integer j;
            j = 0;
            while (j < level_size) begin
                if (j+1 < level_size) begin
                    and_stage[level][j/2] = and_stage[level-1][j] & and_stage[level-1][j+1];
                    or_stage[level][j/2]  = or_stage[level-1][j]  | or_stage[level-1][j+1];
                    xor_stage[level][j/2] = xor_stage[level-1][j] ^ xor_stage[level-1][j+1];
                end else begin
                    // Odd number of elements, carry last element forward
                    and_stage[level][j/2] = and_stage[level-1][j];
                    or_stage[level][j/2]  = or_stage[level-1][j];
                    xor_stage[level][j/2] = xor_stage[level-1][j];
                end
                j = j + 2;
            end
            level_size = (level_size + 1) / 2;
        end

        // The final reduced outputs are at the last stage index 0
        out_and = and_stage[6][0];
        out_or  = or_stage[6][0];
        out_xor = xor_stage[6][0];
    end

endmodule