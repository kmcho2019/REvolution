module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Helper to convert (r,c) to linear index
    function integer idx;
        input integer r, c;
        begin
            idx = (r << 4) + c; // r*16 + c, with shift for synthesis clarity
        end
    endfunction

    // Extract current cell states into 2D wire array for easy neighbor access
    wire cell_state [0:HEIGHT-1][0:WIDTH-1];
    genvar r, c;
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin: row_loop
            for (c = 0; c < WIDTH; c = c + 1) begin: col_loop
                assign cell_state[r][c] = q[idx(r,c)];
            end
        end
    endgenerate

    // Function to wrap coordinates modulo 16 using bitmask (toroid)
    function automatic [3:0] wrap16;
        input integer val;
        begin
            wrap16 = val[3:0];
        end
    endfunction

    // Compute neighbor counts for all cells in parallel using generate and assigns
    wire [3:0] neighbors_count [0:HEIGHT-1][0:WIDTH-1]; // 0..8 count fits in 4 bits
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin: ncount_row
            for (c = 0; c < WIDTH; c = c + 1) begin: ncount_col
                wire [8:0] sum_neighbors;
                // Sum all 8 neighbors (exclude center cell)
                assign sum_neighbors = 
                    cell_state[wrap16(r-1)][wrap16(c-1)] +
                    cell_state[wrap16(r-1)][wrap16(c  )] +
                    cell_state[wrap16(r-1)][wrap16(c+1)] +
                    cell_state[wrap16(r  )][wrap16(c-1)] +
                    cell_state[wrap16(r  )][wrap16(c+1)] +
                    cell_state[wrap16(r+1)][wrap16(c-1)] +
                    cell_state[wrap16(r+1)][wrap16(c  )] +
                    cell_state[wrap16(r+1)][wrap16(c+1)];
                assign neighbors_count[r][c] = sum_neighbors[3:0];
            end
        end
    endgenerate

    // Compute next state bits for all cells per the Game of Life rules
    wire next_state [0:HEIGHT-1][0:WIDTH-1];
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin: next_row
            for (c = 0; c < WIDTH; c = c + 1) begin: next_col
                wire [3:0] nc = neighbors_count[r][c];
                wire curr = cell_state[r][c];
                assign next_state[r][c] = 
                    (nc <= 1) ? 1'b0 :           // 0 or 1 neighbor -> dead
                    (nc == 2) ? curr :           // 2 neighbors -> same state
                    (nc == 3) ? 1'b1 :           // 3 neighbors -> alive
                    1'b0;                        // 4+ neighbors -> dead
            end
        end
    endgenerate

    // Flatten next_state 2D array to next_q 256-bit vector
    wire [255:0] next_q_flat;
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin: flat_row
            for (c = 0; c < WIDTH; c = c + 1) begin: flat_col
                assign next_q_flat[idx(r,c)] = next_state[r][c];
            end
        end
    endgenerate

    // Sequential update of the grid with synchronous load
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q_flat;
    end

endmodule