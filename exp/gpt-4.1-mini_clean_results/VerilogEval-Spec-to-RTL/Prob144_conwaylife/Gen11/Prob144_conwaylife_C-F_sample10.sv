module TopModule (
    input               clk,
    input               load,
    input  [255:0]      data,
    output reg [255:0]  q
);
    localparam N = 16;
    localparam IDX_MASK = 4'hF; // For modulo 16 wrap-around using bitwise AND

    // Create 2D wire array view of current grid state 'q'
    wire grid [0:N-1][0:N-1];
    genvar r, c;
    generate
        for (r = 0; r < N; r = r + 1) begin : GEN_GRID_ROW
            for (c = 0; c < N; c = c + 1) begin : GEN_GRID_COL
                assign grid[r][c] = q[r*N + c];
            end
        end
    endgenerate

    reg [255:0] next_q;

    integer row, col;
    reg [3:0] neighbor_count;
    integer nr, nc;

    always @* begin
        next_q = 256'b0; // Default all dead

        // Iterate over every cell in the 16x16 grid
        for (row = 0; row < N; row = row + 1) begin
            for (col = 0; col < N; col = col + 1) begin
                neighbor_count = 0;

                // Sum over 8 neighbors with wrap-around indices via bit masking
                // Neighbors at offsets: (-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1)
                nr = (row + N - 1) & IDX_MASK; nc = (col + N - 1) & IDX_MASK;
                neighbor_count = neighbor_count + grid[nr][nc];

                nr = (row + N - 1) & IDX_MASK; nc = (col) & IDX_MASK;
                neighbor_count = neighbor_count + grid[nr][nc];

                nr = (row + N - 1) & IDX_MASK; nc = (col + 1) & IDX_MASK;
                neighbor_count = neighbor_count + grid[nr][nc];

                nr = (row) & IDX_MASK; nc = (col + N - 1) & IDX_MASK;
                neighbor_count = neighbor_count + grid[nr][nc];

                nr = (row) & IDX_MASK; nc = (col + 1) & IDX_MASK;
                neighbor_count = neighbor_count + grid[nr][nc];

                nr = (row + 1) & IDX_MASK; nc = (col + N - 1) & IDX_MASK;
                neighbor_count = neighbor_count + grid[nr][nc];

                nr = (row + 1) & IDX_MASK; nc = (col) & IDX_MASK;
                neighbor_count = neighbor_count + grid[nr][nc];

                nr = (row + 1) & IDX_MASK; nc = (col + 1) & IDX_MASK;
                neighbor_count = neighbor_count + grid[nr][nc];

                // Apply the Game of Life rules
                // 0-1 neighbor: cell=0
                // 2 neighbors: cell unchanged
                // 3 neighbors: cell=1
                // 4+ neighbors: cell=0

                if (neighbor_count <= 1)
                    next_q[row*N + col] = 1'b0;
                else if (neighbor_count == 2)
                    next_q[row*N + col] = grid[row][col];
                else if (neighbor_count == 3)
                    next_q[row*N + col] = 1'b1;
                else
                    next_q[row*N + col] = 1'b0;
            end
        end
    end

    // Sequential update on clock edge with synchronous load
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule