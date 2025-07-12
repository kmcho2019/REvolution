module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam ROWS = 16;
    localparam COLS = 16;

    // Internal storage of the grid as 16 rows of 16 bits
    reg [COLS-1:0] grid_rows [0:ROWS-1];
    reg [COLS-1:0] next_grid_rows [0:ROWS-1];

    // Row indices for line-buffering approach
    reg [3:0] current_row_index;  // from 0 to 15
    reg [3:0] processed_rows_count;

    // Registers holding three consecutive rows needed for neighbor calculation:
    // prev_row, curr_row, next_row - used for neighbor counting of current row cells
    reg [COLS-1:0] prev_row;
    reg [COLS-1:0] curr_row;
    reg [COLS-1:0] next_row;

    // Temporary wires for neighbor calculation
    wire [COLS-1:0] curr_left;   // curr_row rotated left by 1 (wrap)
    wire [COLS-1:0] curr_right;  // curr_row rotated right by 1 (wrap)
    wire [COLS-1:0] prev_left;
    wire [COLS-1:0] prev_right;
    wire [COLS-1:0] next_left;
    wire [COLS-1:0] next_right;

    // Rotate functions for left and right neighbors
    function [COLS-1:0] rotate_left;
        input [COLS-1:0] val;
        begin
            rotate_left = {val[COLS-2:0], val[COLS-1]};
        end
    endfunction

    function [COLS-1:0] rotate_right;
        input [COLS-1:0] val;
        begin
            rotate_right = {val[0], val[COLS-1:1]};
        end
    endfunction

    // Compute neighbor bits for each cell in current_row
    assign prev_left  = rotate_left(prev_row);
    assign prev_right = rotate_right(prev_row);
    assign curr_left  = rotate_left(curr_row);
    assign curr_right = rotate_right(curr_row);
    assign next_left  = rotate_left(next_row);
    assign next_right = rotate_right(next_row);

    // neighbor sum for each cell (bitwise sum of 8 neighbors)
    // We'll sum bits with 3 bits per cell for count (range 0..8)
    // Using parallel adders on bitvectors: 
    // We sum the 8 neighbor bit vectors: prev_row, prev_left, prev_right,
    // curr_left, curr_right, next_row, next_left, next_right.

    // We'll create 4 partial sums then combine:
    // partial sum0 = prev_row + prev_left + prev_right
    // partial sum1 = curr_left + curr_right + next_row
    // partial sum2 = next_left + next_right
    // partial sum3 = all zeros (for alignment)

    // The addition is per-bit across the rows. We'll implement a 16-wide 4-bit adder column-wise.

    wire [3:0] neighbor_count [0:COLS-1];

    genvar i;
    generate
        for (i=0; i<COLS; i=i+1) begin : neighbor_count_calc
            wire [3:0] sum0 = prev_row[i] + prev_left[i] + prev_right[i];
            wire [3:0] sum1 = curr_left[i] + curr_right[i] + next_row[i];
            wire [3:0] sum2 = next_left[i] + next_right[i];
            // sum all partial sums to get neighbor_count (0..8)
            wire [4:0] total = sum0 + sum1 + sum2;
            assign neighbor_count[i] = total[3:0]; // max 8 fits in 4 bits
        end
    endgenerate

    // Compute next state row: 
    // rule: 
    // neighbors 0-1 -> 0
    // neighbors 2 -> same as current cell
    // neighbors 3 -> 1
    // neighbors 4+ -> 0

    reg [COLS-1:0] next_row_state;

    integer idx;
    always @(*) begin
        for (idx=0; idx<COLS; idx=idx+1) begin
            case (neighbor_count[idx])
                4'd0, 4'd1: next_row_state[idx] = 1'b0;
                4'd2: next_row_state[idx] = curr_row[idx];
                4'd3: next_row_state[idx] = 1'b1;
                default: next_row_state[idx] = 1'b0; // 4 or more
            endcase
        end
    end

    integer r;
    // Load input data into grid_rows on load signal
    always @(posedge clk) begin
        if (load) begin
            // Unpack 256-bit data to grid_rows
            for (r=0; r<ROWS; r=r+1) begin
                grid_rows[r] <= data[r*COLS +: COLS];
            end
            current_row_index <= 0;
            processed_rows_count <= 0;
            q <= data;
        end else begin
            // For current_row_index, load prev, curr, next rows (with wrap)
            // then compute next_row_state and store it in next_grid_rows[current_row_index]
            // After 16 processed rows, update grid_rows with next_grid_rows and update q.

            // Get row indices for neighbors, modulo 16
            integer prev_idx = (current_row_index == 0) ? (ROWS-1) : (current_row_index - 1);
            integer next_idx = (current_row_index == (ROWS-1)) ? 0 : (current_row_index + 1);

            // Load neighborhood rows for neighbor calculation
            prev_row <= grid_rows[prev_idx];
            curr_row <= grid_rows[current_row_index];
            next_row <= grid_rows[next_idx];

            // Register next row state into buffer
            next_grid_rows[current_row_index] <= next_row_state;

            // Advance to next row
            current_row_index <= current_row_index + 1;
            processed_rows_count <= processed_rows_count + 1;

            // After processing all rows, update grid and output q
            if (processed_rows_count == (ROWS-1)) begin
                for (r=0; r<ROWS; r=r+1) begin
                    grid_rows[r] <= next_grid_rows[r];
                end
                // Pack next_grid_rows into q
                // Use a separate loop to avoid simulation race condition
                reg [255:0] new_q;
                integer rr;
                begin
                    for (rr=0; rr<ROWS; rr=rr+1) begin
                        new_q[rr*COLS +: COLS] = next_grid_rows[rr];
                    end
                    q <= new_q;
                end
                processed_rows_count <= 0;
                current_row_index <= 0;
            end
        end
    end

endmodule