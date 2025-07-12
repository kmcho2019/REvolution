module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Extract a single cell bit from q given row and col with wrap-around
    function bit get_cell;
        input [255:0] state;
        input integer r, c;
        begin
            // Wrap row and column
            integer rr, cc;
            rr = (r < 0) ? (r + N) : ((r >= N) ? (r - N) : r);
            cc = (c < 0) ? (c + N) : ((c >= N) ? (c - N) : c);
            get_cell = state[rr*N + cc];
        end
    endfunction

    // Calculate neighbor count for a cell using three rows slice
    function [3:0] count_neighbors;
        input [15:0] top_row;
        input [15:0] mid_row;
        input [15:0] bot_row;
        input integer col;
        integer cc0, cc1, cc2;
        reg [7:0] neighbors_bits;
        integer i;
        reg [3:0] cnt;
        begin
            // neighbors are the 8 bits around current cell in three rows
            // top_row, mid_row, bot_row represent three rows of 16 bits each
            // We'll select bits at col-1, col, col+1 from each row, except center cell
            cc0 = (col == 0) ? (N - 1) : (col - 1);
            cc1 = col;
            cc2 = (col == N-1) ? 0 : (col + 1);

            neighbors_bits[0] = top_row[cc0];
            neighbors_bits[1] = top_row[cc1];
            neighbors_bits[2] = top_row[cc2];

            neighbors_bits[3] = mid_row[cc0];
            neighbors_bits[4] = mid_row[cc2]; // skip mid_row[col], the cell itself

            neighbors_bits[5] = bot_row[cc0];
            neighbors_bits[6] = bot_row[cc1];
            neighbors_bits[7] = bot_row[cc2];

            // Count number of '1's
            cnt = 0;
            for (i = 0; i < 8; i = i + 1)
                cnt = cnt + neighbors_bits[i];
            count_neighbors = cnt;
        end
    endfunction

    integer r, c;
    reg [15:0] row_above, row_curr, row_below;
    reg [3:0] neighbor_cnt;
    reg cell_val;
    reg [255:0] next_state;

    always @(*) begin
        next_state = 256'b0;
        // For each row
        for (r = 0; r < N; r = r + 1) begin
            // Get rows above, current, below with wrap-around
            row_above = q[((r == 0) ? (N-1)*N : (r-1)*N) +: N];
            row_curr  = q[r*N +: N];
            row_below = q[((r == N-1) ? 0 : (r+1))*N +: N];

            // For each cell in the row
            for (c = 0; c < N; c = c + 1) begin
                cell_val = row_curr[c];
                neighbor_cnt = count_neighbors(row_above, row_curr, row_below, c);

                // Apply rules
                if (neighbor_cnt <= 1)
                    next_state[r*N + c] = 1'b0;
                else if (neighbor_cnt == 2)
                    next_state[r*N + c] = cell_val;
                else if (neighbor_cnt == 3)
                    next_state[r*N + c] = 1'b1;
                else // neighbor_cnt >= 4
                    next_state[r*N + c] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule