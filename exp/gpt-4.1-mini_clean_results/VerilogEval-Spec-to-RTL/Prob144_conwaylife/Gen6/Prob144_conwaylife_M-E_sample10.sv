module TopModule(
    input               clk,
    input               load,
    input       [255:0] data,
    output reg  [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // 2D register array to hold the current grid state
    reg [WIDTH-1:0] grid [0:HEIGHT-1];
    reg [WIDTH-1:0] next_row;

    reg [3:0] row_counter; // Counts from 0 to 15 for pipelined row updates

    // Helper function for wrapping indices modulo 16 using bit masking (mask lower 4 bits)
    function [3:0] wrap_idx;
        input integer idx;
        begin
            wrap_idx = idx[3:0];
        end
    endfunction

    integer c;

    // Compute next_row combinationally based on neighbors of row row_counter
    always @(*) begin
        integer r_prev, r_curr, r_next;
        integer nc[7:0];
        integer neighbors_count;
        reg cell_current;
        r_prev = wrap_idx(row_counter - 1);
        r_curr = wrap_idx(row_counter);
        r_next = wrap_idx(row_counter + 1);

        // For each cell in the row, compute neighbors and next state
        for (c = 0; c < WIDTH; c = c + 1) begin
            // Neighbors indices wrapped around columns
            nc[0] = grid[r_prev][wrap_idx(c - 1)];
            nc[1] = grid[r_prev][wrap_idx(c)];
            nc[2] = grid[r_prev][wrap_idx(c + 1)];
            nc[3] = grid[r_curr][wrap_idx(c - 1)];
            nc[4] = grid[r_curr][wrap_idx(c + 1)];
            nc[5] = grid[r_next][wrap_idx(c - 1)];
            nc[6] = grid[r_next][wrap_idx(c)];
            nc[7] = grid[r_next][wrap_idx(c + 1)];

            neighbors_count = nc[0] + nc[1] + nc[2] + nc[3] + nc[4] + nc[5] + nc[6] + nc[7];
            cell_current = grid[r_curr][c];

            // Apply game rules
            if (neighbors_count <= 1)
                next_row[c] = 1'b0;
            else if (neighbors_count == 2)
                next_row[c] = cell_current;
            else if (neighbors_count == 3)
                next_row[c] = 1'b1;
            else
                next_row[c] = 1'b0;
        end
    end

    // Sequential logic
    always @(posedge clk) begin
        if (load) begin
            // Load data into grid array row-wise
            for (int i = 0; i < HEIGHT; i = i + 1)
                grid[i] <= data[i*WIDTH +: WIDTH];
            row_counter <= 0;
            // Update q to loaded data
            q <= data;
        end else begin
            // Update one row per clock cycle
            grid[row_counter] <= next_row;
            row_counter <= wrap_idx(row_counter + 1);

            // After updating row_counter wraps around, output concatenated grid to q
            if (row_counter == HEIGHT - 1) begin
                integer ri;
                reg [255:0] concat_state;
                concat_state = {256{1'b0}};
                for (ri = 0; ri < HEIGHT; ri = ri + 1)
                    concat_state = concat_state | ( {240'd0, grid[ri]} << (ri*WIDTH) );
                q <= concat_state;
            end
        end
    end

endmodule