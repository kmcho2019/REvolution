module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = 4'hF;

    // Represent grid as 2D array of bits for clarity
    wire [SIZE-1:0] q_rows [SIZE-1:0];
    genvar r, c;
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : ROWS
            for (c = 0; c < SIZE; c = c + 1) begin : COLS
                assign q_rows[r][c] = q[r*SIZE + c];
            end
        end
    endgenerate

    // Wire to hold neighbor count per cell (4 bits sufficient for 0 to 8)
    wire [3:0] neighbor_count [SIZE-1:0][SIZE-1:0];

    generate
        for (r = 0; r < SIZE; r = r + 1) begin : GEN_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : GEN_COL
                wire [8:0] neighbors; // 8 neighbors + current placeholder

                // Compute neighbors with wrapping using masking (mod 16)
                wire [3:0] r_up   = (r == 0) ? MASK : r - 1;
                wire [3:0] r_down = (r == MASK) ? 0 : r + 1;
                wire [3:0] c_left = (c == 0) ? MASK : c - 1;
                wire [3:0] c_right= (c == MASK) ? 0 : c + 1;

                // Assign each neighbor bit
                assign neighbors[0] = q_rows[r_up][c_left];
                assign neighbors[1] = q_rows[r_up][c];
                assign neighbors[2] = q_rows[r_up][c_right];
                assign neighbors[3] = q_rows[r][c_left];
                assign neighbors[4] = 1'b0; // center cell placeholder to exclude from sum
                assign neighbors[5] = q_rows[r][c_right];
                assign neighbors[6] = q_rows[r_down][c_left];
                assign neighbors[7] = q_rows[r_down][c];
                assign neighbors[8] = q_rows[r_down][c_right];

                // Sum neighbors excluding center
                assign neighbor_count[r][c] = neighbors[0] + neighbors[1] + neighbors[2] +
                                             neighbors[3] + neighbors[5] + neighbors[6] +
                                             neighbors[7] + neighbors[8];
            end
        end
    endgenerate

    // Compute next state of each cell based on neighbor count and current cell state
    wire next_state [SIZE-1:0][SIZE-1:0];
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : NEXT_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : NEXT_COL
                // Rules:
                // 0-1 neighbors: 0
                // 2 neighbors: unchanged
                // 3 neighbors: 1
                // 4+ neighbors: 0
                assign next_state[r][c] = (neighbor_count[r][c] == 4'd3) ? 1'b1 :
                                         (neighbor_count[r][c] == 4'd2) ? q_rows[r][c] : 1'b0;
            end
        end
    endgenerate

    // Flatten next_state array into a 256-bit vector for q update
    wire [255:0] next_q_flat;
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : FLATTEN_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : FLATTEN_COL
                assign next_q_flat[r*SIZE + c] = next_state[r][c];
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q_flat;
    end

endmodule