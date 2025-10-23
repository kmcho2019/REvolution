module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam SIZE = 16;
    localparam ROW_BITS = 16;

    // Extract row r from q as 16 bits
    function [ROW_BITS-1:0] get_row(input [255:0] grid, input integer r);
        integer rr;
        begin
            rr = r % SIZE;
            get_row = grid[rr*ROW_BITS +: ROW_BITS];
        end
    endfunction

    // Count neighbors for a single cell (r,c) using three rows: prev, curr, next (each 16 bits)
    // Handles toroidal wrap for columns as well
    function [3:0] count_neighbors(
        input [ROW_BITS-1:0] prev_row,
        input [ROW_BITS-1:0] curr_row,
        input [ROW_BITS-1:0] next_row,
        input integer c
    );
        integer left, right;
        reg [0:0] sum_bits [0:7];
        begin
            // Wrap column indices
            left  = (c == 0) ? SIZE-1 : c-1;
            right = (c == SIZE-1) ? 0 : c+1;

            // 8 neighbors relative to center cell (r,c)
            sum_bits[0] = prev_row[left];
            sum_bits[1] = prev_row[c];
            sum_bits[2] = prev_row[right];

            sum_bits[3] = curr_row[left];
            // center cell itself is excluded here
            sum_bits[4] = curr_row[right];

            sum_bits[5] = next_row[left];
            sum_bits[6] = next_row[c];
            sum_bits[7] = next_row[right];

            count_neighbors = 0;
            for (integer i = 0; i < 8; i = i + 1)
                count_neighbors = count_neighbors + sum_bits[i];
        end
    endfunction

    reg [255:0] next_grid;
    integer row, col;

    always @* begin
        next_grid = 256'b0;
        for (row = 0; row < SIZE; row = row + 1) begin
            // Get rows with wrap-around
            reg [ROW_BITS-1:0] prev_row, curr_row, next_row;
            integer prev_r, next_r;
            prev_r = (row == 0) ? SIZE-1 : row-1;
            next_r = (row == SIZE-1) ? 0 : row+1;
            prev_row = get_row(q, prev_r);
            curr_row = get_row(q, row);
            next_row = get_row(q, next_r);

            for (col = 0; col < SIZE; col = col + 1) begin
                reg [3:0] neighbors;
                reg current_cell;
                neighbors = count_neighbors(prev_row, curr_row, next_row, col);
                current_cell = curr_row[col];

                // Apply rules:
                // 0-1 neighbor: dead
                // 2 neighbors: stay the same
                // 3 neighbors: alive
                // 4+ neighbors: dead
                if (neighbors == 3)
                    next_grid[row*SIZE + col] = 1'b1;
                else if (neighbors == 2)
                    next_grid[row*SIZE + col] = current_cell;
                else
                    next_grid[row*SIZE + col] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_grid;
    end

endmodule