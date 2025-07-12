module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;

    // Represent grid as 16 rows of 16 bits
    reg [15:0] grid [0:15];
    reg [15:0] next_grid [0:15];

    integer row;

    // Helper function: rotate left 1 bit for 16-bit vector
    function [15:0] rotate_left1(input [15:0] val);
        begin
            rotate_left1 = {val[14:0], val[15]};
        end
    endfunction

    // Helper function: rotate right 1 bit for 16-bit vector
    function [15:0] rotate_right1(input [15:0] val);
        begin
            rotate_right1 = {val[0], val[15:1]};
        end
    endfunction

    // Load input data into grid rows
    always @(posedge clk) begin
        if (load) begin
            for (row = 0; row < SIZE; row = row + 1) begin
                grid[row] <= data[ (row*16) +: 16 ];
            end
            // For completeness, clear output q at load
            q <= data;
        end else begin
            // Update the grid state
            for (row = 0; row < SIZE; row = row + 1) begin
                grid[row] <= next_grid[row];
            end
            // Pack grid rows into output vector
            for (row = 0; row < SIZE; row = row + 1) begin
                q[(row*16) +: 16] <= next_grid[row];
            end
        end
    end

    // Compute next_grid combinationally
    always @* begin
        integer r_prev, r_next;
        reg [15:0] up, down, curr;
        reg [15:0] up_left, up_right;
        reg [15:0] down_left, down_right;
        reg [15:0] curr_left, curr_right;

        reg [4:0] neighbor_count [0:15]; // 5 bits to hold sum per cell, max 8 neighbors

        for (row = 0; row < SIZE; row = row + 1) begin
            // Compute wrapped indices for vertical neighbors
            r_prev = (row == 0) ? (SIZE - 1) : (row - 1);
            r_next = (row == SIZE - 1) ? 0 : (row + 1);

            up    = grid[r_prev];
            curr  = grid[row];
            down  = grid[r_next];

            // Rotate rows left and right by 1 bit to get horizontal neighbors
            up_left    = rotate_left1(up);
            up_right   = rotate_right1(up);

            curr_left  = rotate_left1(curr);
            curr_right = rotate_right1(curr);

            down_left  = rotate_left1(down);
            down_right = rotate_right1(down);

            // neighbor_count = sum of all 8 neighbors per bit (exclude cell itself)
            // Sum bits: up_left + up + up_right + curr_left + curr_right + down_left + down + down_right
            // Each bit position sums these bits, result is 0..8

            // Use bitwise addition trick:
            // Sum the 8 neighbor bits per cell using addition of vectors with bit slicing.

            // First sum pairwise
            reg [16:0] sum1, sum2, sum3, sum4; // wider to hold carry

            // sum1 = up_left + up
            sum1 = up_left + up;
            // sum2 = up_right + curr_left
            sum2 = up_right + curr_left;
            // sum3 = curr_right + down_left
            sum3 = curr_right + down_left;
            // sum4 = down + down_right
            sum4 = down + down_right;

            // sum5 = sum1 + sum2
            reg [17:0] sum5 = sum1 + sum2;
            // sum6 = sum3 + sum4
            reg [17:0] sum6 = sum3 + sum4;

            // total_sum = sum5 + sum6
            reg [18:0] total_sum = sum5 + sum6;

            // Now extract neighbor_count bits per cell:
            // We can do this by summing bits per bit position in total_sum
            // But since total_sum is a wide vector, the sum per bit is spread across bits.

            // Instead, we compute neighbor_count per bit by summing bits manually:
            // An alternative approach is to count neighbors per bit position by adding each neighbor bit individually:

            integer bit_idx;
            reg [3:0] nb; // neighbor count 0..8 per cell

            for (bit_idx = 0; bit_idx < SIZE; bit_idx = bit_idx +1) begin
                nb = 0;
                nb = nb + up_left[bit_idx] + up[bit_idx] + up_right[bit_idx]
                       + curr_left[bit_idx] + curr_right[bit_idx]
                       + down_left[bit_idx] + down[bit_idx] + down_right[bit_idx];
                neighbor_count[bit_idx] = nb;
            end

            // Determine next state bits for this row
            reg [15:0] next_row;
            for (bit_idx = 0; bit_idx < SIZE; bit_idx = bit_idx + 1) begin
                // Current cell state
                reg cell = curr[bit_idx];
                reg [3:0] nc = neighbor_count[bit_idx];
                // Apply rules:
                // 0-1 neighbor -> 0
                // 2 neighbors -> no change
                // 3 neighbors -> 1
                // 4+ neighbors -> 0
                if (nc == 4'd2) begin
                    next_row[bit_idx] = cell;
                end else if (nc == 4'd3) begin
                    next_row[bit_idx] = 1'b1;
                end else begin
                    next_row[bit_idx] = 1'b0;
                end
            end

            next_grid[row] = next_row;
        end
    end

endmodule