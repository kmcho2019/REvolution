module TopModule (
    input               clk,
    input               load,
    input  [255:0]      data,
    output reg [255:0]  q
);
    localparam N = 16;       // Grid dimension (rows and cols)
    localparam IDX_MASK = 4'hF; // Mask for modulo 16 wrap-around

    // Create 2D wire array view of current grid state 'q'
    wire grid [0:N-1][0:N-1];
    genvar r, c;
    generate
        for (r = 0; r < N; r = r + 1) begin : GEN_GRID_ROW
            for (c = 0; c < N; c = c + 1) begin : GEN_GRID_COL
                assign grid[r][c] = q[r * N + c];
            end
        end
    endgenerate

    // Wire array for next grid state
    wire next_grid [0:N-1][0:N-1];

    // Combinational neighbor sum calculation and next state determination
    generate
        for (r = 0; r < N; r = r + 1) begin : GEN_NEXT_ROW
            for (c = 0; c < N; c = c + 1) begin : GEN_NEXT_COL
                // Neighbor relative coordinate offsets (8 neighbors)
                // We avoid loops in generate and explicitly list neighbors
                wire [7:0] neighbors_bits;
                assign neighbors_bits[0] = grid[(r + N - 1) & IDX_MASK][(c + N - 1) & IDX_MASK];
                assign neighbors_bits[1] = grid[(r + N - 1) & IDX_MASK][c                 & IDX_MASK];
                assign neighbors_bits[2] = grid[(r + N - 1) & IDX_MASK][(c + 1)     & IDX_MASK];
                assign neighbors_bits[3] = grid[r                 & IDX_MASK][(c + N - 1) & IDX_MASK];
                assign neighbors_bits[4] = grid[r                 & IDX_MASK][(c + 1)     & IDX_MASK];
                assign neighbors_bits[5] = grid[(r + 1)     & IDX_MASK][(c + N - 1) & IDX_MASK];
                assign neighbors_bits[6] = grid[(r + 1)     & IDX_MASK][c                 & IDX_MASK];
                assign neighbors_bits[7] = grid[(r + 1)     & IDX_MASK][(c + 1)     & IDX_MASK];

                // Sum neighbors by summing 8 bits as unsigned integer
                wire [3:0] neighbors_sum; // 4 bits enough to count 0-8
                assign neighbors_sum = neighbors_bits[0] + neighbors_bits[1] + neighbors_bits[2] + neighbors_bits[3] +
                                       neighbors_bits[4] + neighbors_bits[5] + neighbors_bits[6] + neighbors_bits[7];

                // Current cell state
                wire curr_cell = grid[r][c];

                // Apply the rules of the game per problem statement
                assign next_grid[r][c] = (neighbors_sum <= 1) ? 1'b0 :
                                         (neighbors_sum == 2) ? curr_cell :
                                         (neighbors_sum == 3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Flatten next_grid 2D array to a 256-bit vector
    wire [255:0] next_q;
    generate
        for (r = 0; r < N; r = r + 1) begin : GEN_FLATTEN_ROW
            for (c = 0; c < N; c = c + 1) begin : GEN_FLATTEN_COL
                assign next_q[r * N + c] = next_grid[r][c];
            end
        end
    endgenerate

    // Sequential logic: load input or update to next state
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule