module TopModule (
    input               clk,
    input               load,
    input      [255:0]  data,
    output reg [255:0]  q
);

    // Parameters
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Grid stored as 16 rows of 16-bit registers
    reg [WIDTH-1:0] grid [0:HEIGHT-1];
    reg [WIDTH-1:0] next_grid [0:HEIGHT-1];

    integer i;

    // Helper function to compute neighbor count per row using bitwise operations
    // Takes three rows: previous, current, next; returns 4-bit sums for each bit position
    function [WIDTH*4-1:0] neighbor_count_16b;
        input [WIDTH-1:0] upper;
        input [WIDTH-1:0] middle;
        input [WIDTH-1:0] lower;
        reg [WIDTH-1:0] sum;             // sum of neighbors (mod 16)
        reg [WIDTH-1:0] left_mask;
        reg [WIDTH-1:0] right_mask;
        reg [WIDTH-1:0] neighbors;
        reg [WIDTH*4-1:0] counts;        // 4 bits per cell, packed
        reg [3:0] c [0:WIDTH-1];
        integer j;

        // Wrapping shifts with rotate (toroidal wrap)
        // For each row, compute left, right neighbors using rotation
        // left shift by 1 with wrap:
        // For example, left neighbor of bit 0 is bit 15
        // right shift by 1 with wrap:
        // For example, right neighbor of bit 15 is bit 0

        // Generate left and right neighbors for each of the 3 rows
        // Upper neighbors
        reg [WIDTH-1:0] up_left, up_mid, up_right;
        // Middle neighbors (excluding center cell)
        reg [WIDTH-1:0] mid_left, mid_right;
        // Lower neighbors
        reg [WIDTH-1:0] low_left, low_mid, low_right;

        begin
            // Wraparound shifts:
            up_left  = {upper[WIDTH-2:0], upper[WIDTH-1]}; // rotate left by 1
            up_mid   = upper;
            up_right = {upper[0], upper[WIDTH-1:1]};       // rotate right by 1

            mid_left  = {middle[WIDTH-2:0], middle[WIDTH-1]};
            mid_right = {middle[0], middle[WIDTH-1:1]};

            low_left  = {lower[WIDTH-2:0], lower[WIDTH-1]};
            low_mid   = lower;
            low_right = {lower[0], lower[WIDTH-1:1]};

            // Sum neighbors per bit (excluding the center cell middle)
            // sum 8 neighbors = up_left + up_mid + up_right +
            //                   mid_left       + mid_right +
            //                   low_left + low_mid + low_right

            // For bitwise addition of multiple vectors:
            // First sum two vectors, then add next, etc.
            // We'll implement multi-operand bitwise addition using a carry-save like method

            // Bitwise addition of 8 inputs: can do it in stages or by arithmetic

            // Use integer addition via vectors, since vectors can be added arithmetically
            // Because each input is 16 bits, sum of 8 bits max is 8 per cell, fits in 4 bits.

            // Sum neighbors as integer vectors
            // Cast each vector bit to integer by zero extension, sum them per bit

            reg [3:0] sums [0:WIDTH-1];
            integer idx;
            for (idx=0; idx<WIDTH; idx=idx+1) begin
                sums[idx] = 
                      up_left[idx]
                    + up_mid[idx]
                    + up_right[idx]
                    + mid_left[idx]
                    + mid_right[idx]
                    + low_left[idx]
                    + low_mid[idx]
                    + low_right[idx];
            end

            // Pack sums into counts: 4 bits per cell, concatenated, MSB is higher index
            for (j=0; j<WIDTH; j=j+1)
                counts[4*j +: 4] = sums[j];
            neighbor_count_16b = counts;
        end
    endfunction

    // Compute next_grid combinationally
    always @(*) begin
        integer r, c;
        reg [WIDTH*4-1:0] counts;
        reg [3:0] count;
        reg current_cell;
        reg [WIDTH-1:0] upper_row, middle_row, lower_row;

        for (r = 0; r < HEIGHT; r = r + 1) begin
            // Determine neighbor rows with toroidal wrap
            upper_row  = grid[(r == 0) ? HEIGHT-1 : r-1];
            middle_row = grid[r];
            lower_row  = grid[(r == HEIGHT-1) ? 0 : r+1];

            // Get neighbor counts for this row: 4 bits per cell packed
            counts = neighbor_count_16b(upper_row, middle_row, lower_row);

            // Apply rules per cell
            for (c = 0; c < WIDTH; c = c +1) begin
                count = counts[4*c +:4];
                current_cell = middle_row[c];
                // Rules:
                // 0-1 neighbor: cell=0
                // 2 neighbors: cell unchanged
                // 3 neighbors: cell=1
                // 4+ neighbors: cell=0

                if (count <= 1)
                    next_grid[r][c] = 1'b0;
                else if (count == 2)
                    next_grid[r][c] = current_cell;
                else if (count == 3)
                    next_grid[r][c] = 1'b1;
                else
                    next_grid[r][c] = 1'b0;
            end
        end
    end

    // Sequential logic: load or update
    always @(posedge clk) begin
        if (load) begin
            // Load data into grid rows
            for (i = 0; i < HEIGHT; i = i + 1)
                grid[i] <= data[i*WIDTH +: WIDTH];
        end else begin
            // Update to next generation
            for (i = 0; i < HEIGHT; i = i + 1)
                grid[i] <= next_grid[i];
        end

        // Update output q by concatenating rows
        q <= {
            grid[15], grid[14], grid[13], grid[12],
            grid[11], grid[10], grid[9],  grid[8],
            grid[7],  grid[6],  grid[5],  grid[4],
            grid[3],  grid[2],  grid[1],  grid[0]
        };
    end

endmodule