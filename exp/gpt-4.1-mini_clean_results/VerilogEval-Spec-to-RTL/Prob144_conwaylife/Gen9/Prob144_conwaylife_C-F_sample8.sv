module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam SIZE = 16;
    localparam MASK = 4'hF; // For mod16 wrap-around

    // Function: convert row,col to linear index
    function automatic [7:0] idx;
        input [3:0] row;
        input [3:0] col;
        begin
            idx = {row, col}; // row*16 + col via concatenation
        end
    endfunction

    // Function: wrap an integer coordinate to 0..15 using bitmask mod16
    function automatic [3:0] wrap16;
        input integer val;
        begin
            // Add SIZE (16) to handle negative values before masking
            wrap16 = (val + SIZE) & MASK;
        end
    endfunction

    // 2D wire array view of current state q for easy indexing
    wire cell_state [0:SIZE-1][0:SIZE-1];
    genvar r, c;

    generate
        for (r = 0; r < SIZE; r = r + 1) begin : ROWS
            for (c = 0; c < SIZE; c = c + 1) begin : COLS
                assign cell_state[r][c] = q[idx(r,c)];
            end
        end
    endgenerate

    // Compute neighbor counts for each cell in parallel
    wire [3:0] neighbor_count [0:SIZE-1][0:SIZE-1];
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : NEIGHBOR_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : NEIGHBOR_COL
                // Sum the 8 neighbors with wrapping using wrap16
                wire [7:0] sum_neighbors; // 8-bit to safely hold sum up to 8
                assign sum_neighbors =
                      cell_state[wrap16(r - 1)][wrap16(c - 1)] +
                      cell_state[wrap16(r - 1)][wrap16(c    )] +
                      cell_state[wrap16(r - 1)][wrap16(c + 1)] +
                      cell_state[wrap16(r    )][wrap16(c - 1)] +
                      cell_state[wrap16(r    )][wrap16(c + 1)] +
                      cell_state[wrap16(r + 1)][wrap16(c - 1)] +
                      cell_state[wrap16(r + 1)][wrap16(c    )] +
                      cell_state[wrap16(r + 1)][wrap16(c + 1)];

                assign neighbor_count[r][c] = sum_neighbors[3:0]; // max 8 fits in 4 bits
            end
        end
    endgenerate

    // Compute next state per cell according to rules:
    // 0-1 neighbors: dead (0)
    // 2 neighbors: retain current state
    // 3 neighbors: alive (1)
    // 4+ neighbors: dead (0)
    wire next_state [0:SIZE-1][0:SIZE-1];
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : NEXT_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : NEXT_COL
                wire [3:0] nc = neighbor_count[r][c];
                wire curr = cell_state[r][c];
                assign next_state[r][c] =
                    (nc <= 1)  ? 1'b0 :
                    (nc == 2)  ? curr :
                    (nc == 3)  ? 1'b1 :
                    1'b0;
            end
        end
    endgenerate

    // Flatten next_state 2D array into 256-bit wire vector
    wire [255:0] next_q;
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : FLATTEN_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : FLATTEN_COL
                assign next_q[idx(r,c)] = next_state[r][c];
            end
        end
    endgenerate

    // Sequential update: synchronous load or next state update
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule