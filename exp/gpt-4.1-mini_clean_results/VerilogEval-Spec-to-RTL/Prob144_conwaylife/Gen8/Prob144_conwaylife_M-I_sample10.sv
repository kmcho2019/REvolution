module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Internal state registers
    // q holds current state
    // neighbors_sum_reg holds neighbor counts of each cell (4 bits per cell)
    reg [3:0] neighbors_sum_reg [0:N-1][0:N-1];

    // 2D wire view of q for combinational neighbor sum calculation
    wire grid [0:N-1][0:N-1];
    genvar r, c;
    generate
        for (r = 0; r < N; r = r + 1) begin: GRID_ASSIGN
            for (c = 0; c < N; c = c + 1) begin: GRID_ASSIGN_COL
                assign grid[r][c] = q[r*16 + c];
            end
        end
    endgenerate

    // Stage 1 combinational: compute neighbor sums for all cells based on current q
    wire [3:0] neighbors_sum_wire [0:N-1][0:N-1];
    generate
        for (r = 0; r < N; r = r + 1) begin: NEIGHBOR_SUM_ROW
            for (c = 0; c < N; c = c + 1) begin: NEIGHBOR_SUM_COL
                // Wrap indices with localparams for synthesis friendliness
                localparam int r_up    = (r == 0)    ? N-1 : r-1;
                localparam int r_down  = (r == N-1)  ? 0   : r+1;
                localparam int c_left  = (c == 0)    ? N-1 : c-1;
                localparam int c_right = (c == N-1)  ? 0   : c+1;

                assign neighbors_sum_wire[r][c] =
                      grid[r_up][c_left] + grid[r_up][c] + grid[r_up][c_right]
                    + grid[r][c_left]                 + grid[r][c_right]
                    + grid[r_down][c_left] + grid[r_down][c] + grid[r_down][c_right];
            end
        end
    endgenerate

    // Stage 2 combinational: compute next state based on registered neighbors_sum_reg and q
    wire next_state [0:N-1][0:N-1];
    generate
        for (r = 0; r < N; r = r + 1) begin: NEXT_STATE_ROW
            for (c = 0; c < N; c = c + 1) begin: NEXT_STATE_COL
                wire [3:0] nb = neighbors_sum_reg[r][c];
                wire current_cell = grid[r][c];
                assign next_state[r][c] = (nb <= 1) ? 1'b0 :
                                         (nb == 2) ? current_cell :
                                         (nb == 3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Flatten next_state to vector for q update
    wire [255:0] next_q;
    generate
        for (r = 0; r < N; r = r + 1) begin: FLATTEN_NEXT_ROW
            for (c = 0; c < N; c = c + 1) begin: FLATTEN_NEXT_COL
                assign next_q[r*16 + c] = next_state[r][c];
            end
        end
    endgenerate

    integer rr, cc;
    always @(posedge clk) begin
        if (load) begin
            // On load, directly load input data to q and also update neighbors_sum_reg accordingly
            q <= data;
            // Compute neighbors_sum_reg synchronously from loaded data for correct next cycle update
            for (rr = 0; rr < N; rr = rr + 1) begin
                for (cc = 0; cc < N; cc = cc + 1) begin
                    // Wrap indices
                    integer r_up    = (rr == 0)    ? N-1 : rr-1;
                    integer r_down  = (rr == N-1)  ? 0   : rr+1;
                    integer c_left  = (cc == 0)    ? N-1 : cc-1;
                    integer c_right = (cc == N-1)  ? 0   : cc+1;
                    neighbors_sum_reg[rr][cc] <= data[r_up*16 + c_left] + data[r_up*16 + cc] + data[r_up*16 + c_right]
                                              + data[rr*16 + c_left]               + data[rr*16 + c_right]
                                              + data[r_down*16 + c_left] + data[r_down*16 + cc] + data[r_down*16 + c_right];
                end
            end
        end else begin
            // Pipeline stage: register computed neighbors_sum_wire
            for (rr = 0; rr < N; rr = rr + 1) begin
                for (cc = 0; cc < N; cc = cc + 1) begin
                    neighbors_sum_reg[rr][cc] <= neighbors_sum_wire[rr][cc];
                end
            end
            // Update q with next state computed from previous neighbors_sum_reg
            q <= next_q;
        end
    end

endmodule