module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Helper to convert (r,c) to linear index
    function integer idx;
        input integer r, c;
        begin
            idx = (r << 4) + c; // r*16 + c
        end
    endfunction

    // Modular increment and decrement by 1 modulo 16 without negative arithmetic
    function automatic [3:0] dec16;
        input [3:0] val;
        begin
            dec16 = (val == 4'd0) ? 4'd15 : val - 4'd1;
        end
    endfunction

    function automatic [3:0] inc16;
        input [3:0] val;
        begin
            inc16 = (val == 4'd15) ? 4'd0 : val + 4'd1;
        end
    endfunction

    // Extract current cell states into 2D wire array for easier indexing
    wire cell_state [0:HEIGHT-1][0:WIDTH-1];
    genvar r, c;
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin: row_loop
            for (c = 0; c < WIDTH; c = c + 1) begin: col_loop
                assign cell_state[r][c] = q[idx(r,c)];
            end
        end
    endgenerate

    // First stage: compute horizontal sums of triples (left, center, right) for each cell in each row
    // horiz_sum[r][c] = sum of cell_state[r][c-1], cell_state[r][c], cell_state[r][c+1]
    wire [2:0] horiz_sum [0:HEIGHT-1][0:WIDTH-1];
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin: hsum_row
            for (c = 0; c < WIDTH; c = c + 1) begin: hsum_col
                wire [3:0] left_idx = dec16(c[3:0]);
                wire [3:0] right_idx = inc16(c[3:0]);
                assign horiz_sum[r][c] =
                    cell_state[r][left_idx] +
                    cell_state[r][c] +
                    cell_state[r][right_idx];
            end
        end
    endgenerate

    // Second stage: compute neighbor counts by summing horizontal sums of row above, current row, and row below, minus center cell value
    // neighbors_count[r][c] = horiz_sum[r-1][c] + horiz_sum[r][c] + horiz_sum[r+1][c] - cell_state[r][c]
    wire [3:0] neighbors_count [0:HEIGHT-1][0:WIDTH-1];
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin: ncount_row
            for (c = 0; c < WIDTH; c = c + 1) begin: ncount_col
                wire [3:0] r_up = dec16(r[3:0]);
                wire [3:0] r_down = inc16(r[3:0]);
                wire [4:0] sum3rows; // max sum is 3*3=9 bits fit in 5 bits
                assign sum3rows = horiz_sum[r_up][c] + horiz_sum[r][c] + horiz_sum[r_down][c];
                // neighbors_count excludes center cell itself, so subtract cell_state once
                // sum3rows includes cell_state[r][c] once, so neighbors_count = sum3rows - cell_state[r][c]
                assign neighbors_count[r][c] = sum3rows - cell_state[r][c];
            end
        end
    endgenerate

    // Compute next state bits for all cells based on neighbor counts and current state
    wire next_state [0:HEIGHT-1][0:WIDTH-1];
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin: next_row
            for (c = 0; c < WIDTH; c = c + 1) begin: next_col
                wire [3:0] nc = neighbors_count[r][c];
                wire curr = cell_state[r][c];
                assign next_state[r][c] =
                    (nc <= 4'd1) ? 1'b0 :            // 0 or 1 neighbor -> dead
                    (nc == 4'd2) ? curr :            // 2 neighbors -> no change
                    (nc == 4'd3) ? 1'b1 :            // 3 neighbors -> alive
                    1'b0;                           // 4+ neighbors -> dead
            end
        end
    endgenerate

    // Flatten next_state 2D array to next_q 256-bit vector
    wire [255:0] next_q_flat;
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin: flat_row
            for (c = 0; c < WIDTH; c = c + 1) begin: flat_col
                assign next_q_flat[idx(r,c)] = next_state[r][c];
            end
        end
    endgenerate

    // Sequential logic: synchronous load and update of q register
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q_flat;
    end

endmodule