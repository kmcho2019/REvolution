module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // 2D array abstraction of q for easier neighbor referencing
    wire grid [0:N-1][0:N-1];
    genvar r, c;
    generate
        for (r=0; r<N; r=r+1) begin: GRID_ROW
            for (c=0; c<N; c=c+1) begin: GRID_COL
                assign grid[r][c] = q[r*16 + c];
            end
        end
    endgenerate

    // Pipeline registers stage 1: Partial sums of neighbor rows
    // For each cell, compute three partial sums: top row neighbors, middle row neighbors (excluding center cell), bottom row neighbors
    // Partial sums are 3-bit wide because max sum per row of neighbors is 3

    // We'll store partial sums in regs to pipeline (stage1)
    reg [2:0] part_sum_top [0:N-1][0:N-1];
    reg [2:0] part_sum_mid [0:N-1][0:N-1];
    reg [2:0] part_sum_bot [0:N-1][0:N-1];

    // Function to wrap indices for toroidal addressing
    function automatic integer wrap_idx(input integer idx);
        if (idx < 0) wrap_idx = idx + N;
        else if (idx >= N) wrap_idx = idx - N;
        else wrap_idx = idx;
    endfunction

    // Partial sum computation combinational signals
    wire [2:0] part_sum_top_w [0:N-1][0:N-1];
    wire [2:0] part_sum_mid_w [0:N-1][0:N-1];
    wire [2:0] part_sum_bot_w [0:N-1][0:N-1];

    generate
        for (r=0; r<N; r=r+1) begin: PART_SUM_ROW
            for (c=0; c<N; c=c+1) begin: PART_SUM_COL
                localparam integer r_up = (r == 0) ? N-1 : r-1;
                localparam integer r_mid = r;
                localparam integer r_dn = (r == N-1) ? 0 : r+1;

                localparam integer c_l = (c == 0) ? N-1 : c-1;
                localparam integer c_r = (c == N-1) ? 0 : c+1;

                // Top row neighbors (3 cells)
                assign part_sum_top_w[r][c] =
                    grid[r_up][c_l] + grid[r_up][c] + grid[r_up][c_r];

                // Middle row neighbors excluding center cell
                assign part_sum_mid_w[r][c] =
                    grid[r_mid][c_l] + grid[r_mid][c_r];

                // Bottom row neighbors (3 cells)
                assign part_sum_bot_w[r][c] =
                    grid[r_dn][c_l] + grid[r_dn][c] + grid[r_dn][c_r];
            end
        end
    endgenerate

    // Register partial sums at stage 1 on clock edge (or load)
    always @(posedge clk) begin
        if (load) begin
            // on load, zero partial sums since q will be loaded next cycle
            integer rr, cc;
            for (rr=0; rr<N; rr=rr+1) begin
                for (cc=0; cc<N; cc=cc+1) begin
                    part_sum_top[rr][cc] <= 0;
                    part_sum_mid[rr][cc] <= 0;
                    part_sum_bot[rr][cc] <= 0;
                end
            end
        end else begin
            integer rr, cc;
            for (rr=0; rr<N; rr=rr+1) begin
                for (cc=0; cc<N; cc=cc+1) begin
                    part_sum_top[rr][cc] <= part_sum_top_w[rr][cc];
                    part_sum_mid[rr][cc] <= part_sum_mid_w[rr][cc];
                    part_sum_bot[rr][cc] <= part_sum_bot_w[rr][cc];
                end
            end
        end
    end

    // Stage 2: sum partial sums to get total neighbors (max 8 neighbors, so 4 bits)
    reg [3:0] neighbors_sum [0:N-1][0:N-1];
    // Also pipeline the grid state (q) for alignment with neighbors_sum stage
    reg grid_reg [0:N-1][0:N-1];

    always @(posedge clk) begin
        if (load) begin
            integer rr, cc;
            for (rr=0; rr<N; rr=rr+1) begin
                for (cc=0; cc<N; cc=cc+1) begin
                    neighbors_sum[rr][cc] <= 0;
                    grid_reg[rr][cc] <= 0;
                end
            end
        end else begin
            integer rr, cc;
            for (rr=0; rr<N; rr=rr+1) begin
                for (cc=0; cc<N; cc=cc+1) begin
                    neighbors_sum[rr][cc] <= part_sum_top[rr][cc] + part_sum_mid[rr][cc] + part_sum_bot[rr][cc];
                    grid_reg[rr][cc] <= grid[rr][cc];
                end
            end
        end
    end

    // Stage 3: Apply rules combinationally to get next state
    wire next_cell_state [0:N-1][0:N-1];

    generate
        for (r=0; r<N; r=r+1) begin: NEXT_STATE_ROW
            for (c=0; c<N; c=c+1) begin: NEXT_STATE_COL
                assign next_cell_state[r][c] =
                    (neighbors_sum[r][c] <= 1) ? 1'b0 :
                    (neighbors_sum[r][c] == 2) ? grid_reg[r][c] :
                    (neighbors_sum[r][c] == 3) ? 1'b1 :
                    1'b0;
            end
        end
    endgenerate

    // Flatten next_cell_state for output register update
    wire [255:0] next_state_flat;
    generate
        for (r=0; r<N; r=r+1) begin: FLATTEN_ROW
            for (c=0; c<N; c=c+1) begin: FLATTEN_COL
                assign next_state_flat[r*16 + c] = next_cell_state[r][c];
            end
        end
    endgenerate

    // Final output register update with load priority
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state_flat;
    end

endmodule