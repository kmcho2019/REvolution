module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Parameters
    localparam SIZE = 16;
    localparam ROW_WIDTH = SIZE;

    // Internal representation: 16 rows of 16 bits each
    reg [ROW_WIDTH-1:0] rows [0:SIZE-1];
    reg [ROW_WIDTH-1:0] next_rows [0:SIZE-1];

    integer i;

    // Helper function: rotate right by 1 bit (wrap-around horizontal neighbors)
    function [ROW_WIDTH-1:0] rotate_right_1(input [ROW_WIDTH-1:0] in);
        rotate_right_1 = {in[0], in[ROW_WIDTH-1:1]};
    endfunction

    // Helper function: rotate left by 1 bit (wrap-around horizontal neighbors)
    function [ROW_WIDTH-1:0] rotate_left_1(input [ROW_WIDTH-1:0] in);
        rotate_left_1 = {in[ROW_WIDTH-2:0], in[ROW_WIDTH-1]};
    endfunction

    // Load data input into rows on load
    always @(posedge clk) begin
        if (load) begin
            // Unpack 256-bit vector into 16 rows of 16 bits
            for (i = 0; i < SIZE; i = i + 1) begin
                rows[i] <= data[i*ROW_WIDTH +: ROW_WIDTH];
            end
            q <= data;
        end else begin
            // Update all rows simultaneously with next_rows
            for (i = 0; i < SIZE; i = i + 1) begin
                rows[i] <= next_rows[i];
            end
            // Pack rows back into q
            for (i = 0; i < SIZE; i = i + 1) begin
                q[i*ROW_WIDTH +: ROW_WIDTH] <= next_rows[i];
            end
        end
    end

    // Compute next state combinationally
    always @* begin
        // For toroidal vertical wrap-around, compute indices above and below each row
        // row_up = (i + SIZE -1) % SIZE, row_down = (i + 1) % SIZE
        integer r_up, r_down;
        reg [ROW_WIDTH-1:0] row_up, row_mid, row_down;
        reg [ROW_WIDTH-1:0] neigh_left, neigh_mid, neigh_right;
        reg [ROW_WIDTH-1:0] neighbor_sum_low [0:7]; // partial sums at bit level
        integer bit_idx;

        // We'll compute neighbor counts for all rows in parallel here
        for (i = 0; i < SIZE; i = i + 1) begin
            r_up   = (i == 0) ? (SIZE - 1) : (i - 1);
            r_down = (i == SIZE -1) ? 0 : (i + 1);

            row_up  = rows[r_up];
            row_mid = rows[i];
            row_down = rows[r_down];

            // Compute neighbor bit sets:
            // neighbors for each cell: 8 neighbors = 
            // above row (left, mid, right), current row (left, right), below row (left, mid, right)

            // For left and right neighbors, use rotate functions for wrap-around horizontally
            // Horizontal shifts act as column neighbors

            // Neighbor bit sets (1 if neighbor alive, 0 if dead)
            neigh_left[0] = rotate_right_1(row_up);
            neigh_mid[0]  = row_up;
            neigh_right[0] = rotate_left_1(row_up);

            neigh_left[1] = rotate_right_1(row_mid);
            neigh_mid[1]  = 0;              // exclude self-cell itself
            neigh_right[1] = rotate_left_1(row_mid);

            neigh_left[2] = rotate_right_1(row_down);
            neigh_mid[2]  = row_down;
            neigh_right[2] = rotate_left_1(row_down);

            // Sum all neighbors: total 8 neighbors per cell

            // Combine all neighbor bits by bitwise OR for debug, but we need sum, not OR
            // So we sum bits from these 8 sets per bit position

            // Use addition trees to sum 8 one-bit neighbor values per cell (bit position)

            // Each of the above neighbors is one bit per cell; so we will sum:
            // neigh_left[0], neigh_mid[0], neigh_right[0],
            // neigh_left[1], neigh_right[1],
            // neigh_left[2], neigh_mid[2], neigh_right[2]

            // Sum in parts to reduce code repetition

            // First sum triples of bits at each bit position
            reg [3:0] sum_neighbors [0:ROW_WIDTH-1]; // max sum 8 fits in 4 bits

            for (bit_idx = 0; bit_idx < ROW_WIDTH; bit_idx = bit_idx + 1) begin
                integer s;
                s = 0;
                s = s 
                    + neigh_left[0][bit_idx]
                    + neigh_mid[0][bit_idx]
                    + neigh_right[0][bit_idx]
                    + neigh_left[1][bit_idx]
                    + neigh_right[1][bit_idx]
                    + neigh_left[2][bit_idx]
                    + neigh_mid[2][bit_idx]
                    + neigh_right[2][bit_idx];
                sum_neighbors[bit_idx] = s[3:0];
            end

            // Now apply the game rules per cell using sum_neighbors and current cell state
            // Rules:
            // 0-1 neighbor: 0
            // 2 neighbors: cell state unchanged
            // 3 neighbors: 1
            // 4+ neighbors: 0

            for (bit_idx = 0; bit_idx < ROW_WIDTH; bit_idx = bit_idx + 1) begin
                case (sum_neighbors[bit_idx])
                    4'd2: next_rows[i][bit_idx] = row_mid[bit_idx]; // unchanged
                    4'd3: next_rows[i][bit_idx] = 1'b1;
                    default: next_rows[i][bit_idx] = 1'b0;
                endcase
            end
        end
    end

endmodule