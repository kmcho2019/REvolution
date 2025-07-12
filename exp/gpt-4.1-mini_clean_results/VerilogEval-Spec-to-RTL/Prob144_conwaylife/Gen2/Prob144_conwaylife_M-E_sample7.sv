module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Represent grid as 16 rows of 16 bits each
    reg [N-1:0] grid [0:N-1];       // Current state rows
    reg [N-1:0] next_grid [0:N-1];  // Next state rows

    integer r;

    // Convert flat 256-bit vector 'data' into 16 rows
    wire [N-1:0] input_rows [0:N-1];
    genvar gi;
    generate
        for (gi = 0; gi < N; gi = gi + 1) begin
            assign input_rows[gi] = data[gi*16 +: 16];
        end
    endgenerate

    // Helper functions for circular rotations of 16-bit rows
    function [N-1:0] rotl1(input [N-1:0] in);
        rotl1 = {in[N-2:0], in[N-1]};
    endfunction

    function [N-1:0] rotr1(input [N-1:0] in);
        rotr1 = {in[0], in[N-1:1]};
    endfunction

    // Count neighbors for a single row
    // For row i, neighbors come from row above, row itself, row below
    // Using toroidal wraparound for rows: (i-1) mod 16, i, (i+1) mod 16
    function [3*N-1:0] count_neighbors(input [N-1:0] row_above,
                                        input [N-1:0] row_curr,
                                        input [N-1:0] row_below);
        // Each cell's neighbors are the sum of the 8 surrounding bits:
        // left, center, right of above row
        // left, right of current row (excluding center cell)
        // left, center, right of below row
        reg [N-1:0] sum_neighbors;
        reg [N-1:0] s_above, s_curr, s_below;
        integer i;
        reg [3:0] count_cells [0:N-1];
        reg [3*N-1:0] packed_counts;

        begin
            // For each neighbor direction, get shifted rows (with wrap)
            // Neighbors for each cell:
            // above row: left, center, right
            s_above = rotl1(row_above) + row_above + rotr1(row_above);
            // current row neighbors: left and right only (exclude center)
            s_curr = rotl1(row_curr) + rotr1(row_curr);
            // below row: left, center, right
            s_below = rotl1(row_below) + row_below + rotr1(row_below);

            // total neighbor count = sum of all above
            // Note this sum can be from 0 to 8 per cell; each cell count stored in 4 bits
            // We'll extract each bit of neighbors per cell below

            // sum neighbors bitwise: for each bit position sum bits from s_above, s_curr, s_below
            // We will count neighbors bitwise by summing their bits per cell

            // Since s_above, s_curr, s_below are bitwise sums (0..3), adding them gives 0..8
            // We'll count neighbors per bit by bitwise addition

            // We'll perform 3 separate addition of three 3-bit quantities per bit position:
            // To get a fast count, convert each bit of s_above, s_curr, s_below into 1 or 0 and sum.

            // Alternative approach: Using bitwise counts:
            // Use a parallel counting approach with bit slicing:
            // Count bits from s_above, s_curr, s_below for each bit position

            // Use simple arithmetic since each s_* is the sum of bits for the neighbors on that row.

            // Since s_above, s_curr, s_below are 16-bit vectors where each bit is 0 or 1
            // Actually, these vectors are sums from 1 to 3 bits per cell position, we need the actual count per cell.

            // So s_above, s_curr, s_below are 16-bit vectors whose bits are sums from 0 to 3 but stored as bits
            // This sum is done by '+' operator at bit level, so result is larger width than 1 bit

            // Because we summed bitwise addition, s_above is from 0 to 3 per bit, stored as multiple bits per position.
            // Actually, '+' operator on 16-bit vectors is not bitwise but adds the entire vector numerically.
            // So the above '+' operation is invalid for bitwise neighbor count.

            // We need to count neighbors per cell by adding neighbor bits:
            // For each of the 8 neighbors (left, right, above, below, diagonals), we add their bit value.

            // We'll compute neighbor counts per bit as follows:

            // Prepare all 8 neighbor directions as bit vectors:

            // Neighbors for each cell (bit) come from the following 8 positions:
            // Above row: left, center, right
            // Current row: left, right
            // Below row: left, center, right

            // So neighbor bits are:
            reg [N-1:0] neighbors_vec [0:7];

            neighbors_vec[0] = rotl1(row_above); // above-left
            neighbors_vec[1] = row_above;        // above-center
            neighbors_vec[2] = rotr1(row_above); // above-right
            neighbors_vec[3] = rotl1(row_curr);  // left
            neighbors_vec[4] = rotr1(row_curr);  // right
            neighbors_vec[5] = rotl1(row_below); // below-left
            neighbors_vec[6] = row_below;        // below-center
            neighbors_vec[7] = rotr1(row_below); // below-right

            // Now sum these 8 vectors bitwise per bit (cell)

            // Use a 8-bit vector to add bits for each cell position:
            // We'll sum them by 4-bit counters per bit.

            // Initialize counts:
            for (i=0; i<N; i=i+1) begin
                count_cells[i] = 0;
                integer n;
                for (n=0; n<8; n=n+1) begin
                    count_cells[i] = count_cells[i] + neighbors_vec[n][i];
                end
            end

            // Pack counts into a 3*N bits vector to return
            // Each count is 4 bits, but max is 8 (3 bits sufficient)
            // Pack counts as concatenation count_cells[15], count_cells[14], ..., count_cells[0]
            // with 3 bits per count for output, big endian order
            packed_counts = 0;
            for (i=0; i<N; i=i+1) begin
                packed_counts = packed_counts | (count_cells[i][2:0] << (i*3));
            end

            count_neighbors = packed_counts;
        end
    endfunction

    // On each clock, load data if load=1, else compute next state
    always @(posedge clk) begin
        if (load) begin
            // Load data to grid rows
            for (r = 0; r < N; r = r + 1) begin
                grid[r] <= input_rows[r];
            end
        end else begin
            // Compute next state
            reg [3*N-1:0] nb_count_row;
            integer rr, c;
            reg curr_bit, next_bit;
            for (r = 0; r < N; r = r + 1) begin
                // Identify rows with toroidal wrap:
                // above row:
                rr = (r == 0) ? N-1 : r-1;
                reg [N-1:0] row_above = grid[rr];
                reg [N-1:0] row_curr = grid[r];
                rr = (r == N-1) ? 0 : r+1;
                reg [N-1:0] row_below = grid[rr];

                nb_count_row = count_neighbors(row_above, row_curr, row_below);

                // Compute next row bits using rules:
                for (c = 0; c < N; c = c + 1) begin
                    curr_bit = row_curr[c];
                    // Extract neighbor count for cell c (3 bits)
                    // in nb_count_row bits [3*c +: 3]
                    reg [2:0] ncount;
                    ncount = nb_count_row[c*3 +: 3];
                    // Apply rules:
                    // 0-1 neighbors: dead (0)
                    // 2 neighbors: stays same
                    // 3 neighbors: alive (1)
                    // 4+ neighbors: dead (0)
                    if (ncount == 3'd2) begin
                        next_bit = curr_bit;
                    end else if (ncount == 3'd3) begin
                        next_bit = 1'b1;
                    end else begin
                        next_bit = 1'b0;
                    end
                    next_grid[r][c] = next_bit;
                end
            end

            // Update grid with next state
            for (r = 0; r < N; r = r + 1) begin
                grid[r] <= next_grid[r];
            end
        end
    end

    // Pack grid rows into output q
    always @(*) begin
        for (r = 0; r < N; r = r + 1) begin
            q[r*16 +: 16] = grid[r];
        end
    end

endmodule