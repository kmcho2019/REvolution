module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Convert (r,c) to bit index in q vector
    function integer idx(input integer r, input integer c);
        begin
            // r and c are 0..15
            idx = (r * WIDTH) + c;
        end
    endfunction

    // Wrap index modulo 16
    function [3:0] wrap16(input integer val);
        begin
            wrap16 = val[3:0];
        end
    endfunction

    // Line buffers hold rows of the grid for neighbor calc:
    // prev_row: row above current row
    // curr_row: current row
    // next_row: row below current row
    reg [WIDTH-1:0] prev_row, curr_row, next_row;

    // Row counter to track which row is currently being computed in this pipeline
    reg [3:0] row_cnt;

    // Column counter for clarity (not strictly required as we process whole rows combinationally)
    // We update entire rows in one cycle combinationally.

    // Next row state buffer (to be shifted into q after processing all columns)
    reg [WIDTH-1:0] next_row_state;

    // A register to accumulate the updated q bits during the 16-step computation cycle
    reg [255:0] q_next;

    integer c;

    // Compute neighbor count for a single cell in the current processing row and column
    function [3:0] neighbor_count;
        input [WIDTH-1:0] prev;
        input [WIDTH-1:0] curr;
        input [WIDTH-1:0] next;
        input integer col;
        reg [3:0] count;
        integer left, right;
        begin
            left  = wrap16(col - 1);
            right = wrap16(col + 1);
            count = 0;

            // Sum the 8 neighbors:
            // prev row neighbors
            count = count + prev[left] + prev[col] + prev[right];
            // current row neighbors (excluding center cell)
            count = count + curr[left] + curr[right];
            // next row neighbors
            count = count + next[left] + next[col] + next[right];

            neighbor_count = count;
        end
    endfunction

    // On load: initialize q and prepare line buffers and counters
    // Otherwise, pipeline updates one row per cycle
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            row_cnt <= 4'd0;

            // Load line buffers with corresponding rows from data, wrapping around toroidally
            // Initialize prev_row = q[15], curr_row = q[0], next_row = q[1]
            prev_row <= data[idx(HEIGHT-1,0) +: WIDTH];
            curr_row <= data[idx(0,0) +: WIDTH];
            next_row <= data[idx(1,0) +: WIDTH];

            q_next <= data; // start next q as current q
        end else begin
            // Compute next row's updated cells and store in next_row_state
            for (c = 0; c < WIDTH; c = c + 1) begin
                // Count neighbors of cell (row_cnt, c)
                // Current cell's state in curr_row
                // Use neighbor_count function on the three line buffers and current column c
                reg [3:0] nc;
                reg curr_cell;
                curr_cell = curr_row[c];
                nc = neighbor_count(prev_row, curr_row, next_row, c);

                // Apply Game of Life rules:
                // (1) 0-1 neighbor: cell dead (0)
                // (2) 2 neighbors: cell state unchanged
                // (3) 3 neighbors: cell alive (1)
                // (4) 4+ neighbors: cell dead (0)
                if (nc <= 1)
                    next_row_state[c] = 1'b0;
                else if (nc == 2)
                    next_row_state[c] = curr_cell;
                else if (nc == 3)
                    next_row_state[c] = 1'b1;
                else
                    next_row_state[c] = 1'b0;
            end

            // Update q_next with the processed row
            for (c = 0; c < WIDTH; c = c + 1)
                q_next[idx(row_cnt, c)] <= next_row_state[c];

            // Rotate line buffers for next cycle
            // Move down one row: prev_row <= curr_row, curr_row <= next_row,
            // next_row <= next row in q, wrapping around
            prev_row <= curr_row;
            curr_row <= next_row;
            // next_row is read from q_next (the updated q) to reflect new state, wrapping row+2
            next_row <= q_next[idx(wrap16(row_cnt + 2), 0) +: WIDTH];

            // Increment row counter
            if (row_cnt == HEIGHT - 1) begin
                row_cnt <= 4'd0;
                // Commit q_next into q after full update of all rows
                q <= q_next;
            end else begin
                row_cnt <= row_cnt + 1;
            end
        end
    end

endmodule