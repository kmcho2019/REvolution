module TopModule (
    input               clk,
    input               load,
    input  [255:0]      data,
    output reg [255:0]  q
);

    localparam N = 16;
    localparam IDX_MASK = 4'hF;  // for modulo 16 wrap-around

    // 2D view of current state q
    wire grid [0:N-1][0:N-1];
    genvar r, c;
    generate
        for (r = 0; r < N; r = r + 1) begin : GEN_GRID_ROW
            for (c = 0; c < N; c = c + 1) begin : GEN_GRID_COL
                // Using shift instead of multiply for index calculation
                assign grid[r][c] = q[(r << 4) + c];
            end
        end
    endgenerate

    // Compute next state grid
    wire next_grid [0:N-1][0:N-1];

    // Balanced summation of 8 neighbors to reduce logic depth
    // Neighbors are explicitly listed and wrapped by IDX_MASK

    generate
        for (r = 0; r < N; r = r + 1) begin : GEN_NEXT_ROW
            for (c = 0; c < N; c = c + 1) begin : GEN_NEXT_COL
                // Collect neighbors bits
                wire n0 = grid[(r + N - 1) & IDX_MASK][(c + N - 1) & IDX_MASK];
                wire n1 = grid[(r + N - 1) & IDX_MASK][c & IDX_MASK];
                wire n2 = grid[(r + N - 1) & IDX_MASK][(c + 1) & IDX_MASK];
                wire n3 = grid[r & IDX_MASK][(c + N - 1) & IDX_MASK];
                wire n4 = grid[r & IDX_MASK][(c + 1) & IDX_MASK];
                wire n5 = grid[(r + 1) & IDX_MASK][(c + N - 1) & IDX_MASK];
                wire n6 = grid[(r + 1) & IDX_MASK][c & IDX_MASK];
                wire n7 = grid[(r + 1) & IDX_MASK][(c + 1) & IDX_MASK];

                // Partial sums to build a balanced adder tree
                wire [1:0] sum01 = n0 + n1;
                wire [1:0] sum23 = n2 + n3;
                wire [1:0] sum45 = n4 + n5;
                wire [1:0] sum67 = n6 + n7;

                wire [2:0] sum0123 = sum01 + sum23;
                wire [2:0] sum4567 = sum45 + sum67;

                wire [3:0] neighbors_sum = sum0123 + sum4567;

                wire curr_cell = grid[r][c];

                // Apply rules as per problem:
                // 0-1 neighbors: dead (0)
                // 2 neighbors: stays same
                // 3 neighbors: alive (1)
                // 4+ neighbors: dead (0)
                assign next_grid[r][c] = (neighbors_sum <= 1) ? 1'b0 :
                                         (neighbors_sum == 2) ? curr_cell :
                                         (neighbors_sum == 3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Flatten next_grid to 256-bit vector next_q using shift instead of multiply
    wire [255:0] next_q;
    generate
        for (r = 0; r < N; r = r + 1) begin : GEN_FLATTEN_ROW
            for (c = 0; c < N; c = c + 1) begin : GEN_FLATTEN_COL
                assign next_q[(r << 4) + c] = next_grid[r][c];
            end
        end
    endgenerate

    // Sequential state update with synchronous load
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule