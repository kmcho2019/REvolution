module TopModule(
    input               clk,
    input               load,
    input       [255:0] data,
    output reg  [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Convert packed vector q to 2D array for neighbor calculation
    wire [0:0] grid [0:HEIGHT-1][0:WIDTH-1];
    genvar r, c;
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                assign grid[r][c] = q[r*WIDTH + c];
            end
        end
    endgenerate

    // Compute neighbor count and next state for each cell
    wire [3:0] neighbors [0:HEIGHT-1][0:WIDTH-1]; // up to 8 neighbors => max 8 (4 bits)
    wire next_state [0:HEIGHT-1][0:WIDTH-1];

    genvar dr, dc;
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : ROWS
            for (c = 0; c < WIDTH; c = c + 1) begin : COLS
                wire [3:0] count_neighbors;
                wire [0:0] current_cell = grid[r][c];
                // Sum neighbors
                wire [0:0] neighbors_bits [0:7];
                // neighbors indexed as offsets: (-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1)
                assign neighbors_bits[0] = grid[(r + HEIGHT - 1) & 4'hF][(c + WIDTH - 1) & 4'hF];
                assign neighbors_bits[1] = grid[(r + HEIGHT - 1) & 4'hF][c];
                assign neighbors_bits[2] = grid[(r + HEIGHT - 1) & 4'hF][(c + 1) & 4'hF];
                assign neighbors_bits[3] = grid[r][(c + WIDTH - 1) & 4'hF];
                assign neighbors_bits[4] = grid[r][(c + 1) & 4'hF];
                assign neighbors_bits[5] = grid[(r + 1) & 4'hF][(c + WIDTH - 1) & 4'hF];
                assign neighbors_bits[6] = grid[(r + 1) & 4'hF][c];
                assign neighbors_bits[7] = grid[(r + 1) & 4'hF][(c + 1) & 4'hF];

                assign count_neighbors = neighbors_bits[0] + neighbors_bits[1] + neighbors_bits[2] + neighbors_bits[3]
                                        + neighbors_bits[4] + neighbors_bits[5] + neighbors_bits[6] + neighbors_bits[7];

                assign neighbors[r][c] = count_neighbors;

                // Apply rules:
                // 0-1 neighbor: 0
                // 2 neighbors: no change
                // 3 neighbors: 1
                // 4+ neighbors: 0
                assign next_state[r][c] = (count_neighbors == 2) ? current_cell :
                                          (count_neighbors == 3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Pack next_state 2D array into next_q vector
    wire [255:0] next_q;
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : PACK_ROW
            for (c = 0; c < WIDTH; c = c + 1) begin : PACK_COL
                assign next_q[r*WIDTH + c] = next_state[r][c];
            end
        end
    endgenerate

    // Sequential logic: load data or update to next state
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule