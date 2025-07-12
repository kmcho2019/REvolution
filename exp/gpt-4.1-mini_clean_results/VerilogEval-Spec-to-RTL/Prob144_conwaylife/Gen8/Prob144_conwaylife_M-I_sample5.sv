module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // 2D representation of current grid state q
    wire [0:0] grid [0:N-1][0:N-1];
    genvar r, c;
    generate
        for (r = 0; r < N; r = r + 1) begin : assign_grid_row
            for (c = 0; c < N; c = c + 1) begin : assign_grid_col
                assign grid[r][c] = q[r*16 + c];
            end
        end
    endgenerate

    // Registers to hold neighbor sums (4 bits per cell, max 8)
    reg [3:0] neighbor_sum_reg [0:N-1][0:N-1];

    // Next state registers computed from neighbor sums and current state
    reg next_state_reg [0:N-1][0:N-1];

    // Combinational calculation of neighbor sum for each cell
    // Stored in wire array before registering
    wire [3:0] neighbor_sum_wire [0:N-1][0:N-1];

    // Function for index wrapping
    function automatic integer wrap_idx;
        input integer idx;
        begin
            if (idx < 0)
                wrap_idx = idx + N;
            else if (idx >= N)
                wrap_idx = idx - N;
            else
                wrap_idx = idx;
        end
    endfunction

    generate
        for (r = 0; r < N; r = r + 1) begin : gen_row
            for (c = 0; c < N; c = c + 1) begin : gen_col
                // Neighbor indices wrapped
                localparam int ru = (r == 0) ? N-1 : r - 1;
                localparam int rd = (r == N-1) ? 0 : r + 1;
                localparam int cl = (c == 0) ? N-1 : c - 1;
                localparam int cr = (c == N-1) ? 0 : c + 1;

                // Sum neighbors (8 neighbors)
                assign neighbor_sum_wire[r][c] =
                    grid[ru][cl] + grid[ru][c] + grid[ru][cr] +
                    grid[r][cl]            + grid[r][cr] +
                    grid[rd][cl] + grid[rd][c] + grid[rd][cr];
            end
        end
    endgenerate

    integer i, j;

    // Stage 1: On clock edge, register neighbor sums unless loading (load resets sums)
    always @(posedge clk) begin
        if (load) begin
            // Reset neighbor sums and next_state_reg on load
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    neighbor_sum_reg[i][j] <= 0;
                    next_state_reg[i][j] <= 0;
                end
            end
        end else begin
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    neighbor_sum_reg[i][j] <= neighbor_sum_wire[i][j];
                end
            end
        end
    end

    // Stage 2: Compute next state from registered neighbor sums and current state q
    always @(posedge clk) begin
        if (load) begin
            // Load new state directly into q, also update next_state_reg with loaded data for pipeline consistency
            q <= data;
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    next_state_reg[i][j] <= data[i*16 + j];
                end
            end
        end else begin
            // Compute next state from registered neighbor sums and current grid state q
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    case (neighbor_sum_reg[i][j])
                        0,1: next_state_reg[i][j] <= 1'b0;
                        2:    next_state_reg[i][j] <= grid[i][j];
                        3:    next_state_reg[i][j] <= 1'b1;
                        default: next_state_reg[i][j] <= 1'b0;
                    endcase
                end
            end
            // Update q by flattening next_state_reg 2D array
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    q[i*16 + j] <= next_state_reg[i][j];
                end
            end
        end
    end

endmodule