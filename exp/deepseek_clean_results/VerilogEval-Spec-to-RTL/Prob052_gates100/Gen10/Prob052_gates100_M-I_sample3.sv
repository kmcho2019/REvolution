module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree reduction for AND operation
    localparam AND_LEVELS = 7; // ceil(log2(100)) = 7
    wire [99:0] and_tree [0:AND_LEVELS];
    assign and_tree[0] = in;
    genvar i;
    generate
        for (i = 0; i < AND_LEVELS; i = i + 1) begin : and_tree_gen
            integer j;
            always @(*) begin
                for (j = 0; j < 100; j = j + (1 << (i+1))) begin
                    if (j + (1 << i) < 100) begin
                        and_tree[i+1][j] = and_tree[i][j] & and_tree[i][j + (1 << i)];
                    end else begin
                        and_tree[i+1][j] = and_tree[i][j];
                    end
                end
            end
        end
    endgenerate
    assign out_and = and_tree[AND_LEVELS][0];

    // Tree reduction for OR operation
    localparam OR_LEVELS = 7;
    wire [99:0] or_tree [0:OR_LEVELS];
    assign or_tree[0] = in;
    genvar k;
    generate
        for (k = 0; k < OR_LEVELS; k = k + 1) begin : or_tree_gen
            integer l;
            always @(*) begin
                for (l = 0; l < 100; l = l + (1 << (k+1))) begin
                    if (l + (1 << k) < 100) begin
                        or_tree[k+1][l] = or_tree[k][l] | or_tree[k][l + (1 << k)];
                    end else begin
                        or_tree[k+1][l] = or_tree[k][l];
                    end
                end
            end
        end
    endgenerate
    assign out_or = or_tree[OR_LEVELS][0];

    // Efficient XOR (parity) calculation
    assign out_xor = ^in; // Synthesis tools optimize this well

endmodule