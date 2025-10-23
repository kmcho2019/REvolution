module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // 2D wire array alias for current state bits
    wire grid [0:N-1][0:N-1];
    genvar r, c;

    generate
        for (r = 0; r < N; r = r + 1) begin : ROWS
            for (c = 0; c < N; c = c + 1) begin : COLS
                assign grid[r][c] = q[r*16 + c];
            end
        end
    endgenerate

    // Function: popcount of 8 bits - implemented as parallel add tree
    // input: 8-bit vector, output: 4-bit count (0 to 8)
    function automatic [3:0] popcount8;
        input [7:0] bits;
        reg [3:0] count;
        integer i;
        begin
            count = 0;
            for (i = 0; i < 8; i = i + 1)
                count = count + bits[i];
            popcount8 = count;
        end
    endfunction

    // Next state wire 2D array
    wire next_grid [0:N-1][0:N-1];

    generate
        for (r = 0; r < N; r = r + 1) begin : CALC_ROW
            for (c = 0; c < N; c = c + 1) begin : CALC_COL
                // Precompute wrap indices as localparams for synthesis clarity
                localparam int r_up    = (r == 0)    ? N-1 : r-1;
                localparam int r_down  = (r == N-1)  ? 0   : r+1;
                localparam int c_left  = (c == 0)    ? N-1 : c-1;
                localparam int c_right = (c == N-1)  ? 0   : c+1;

                // Extract neighbors into a bus [7:0]
                wire [7:0] neighbors_bits;
                assign neighbors_bits = {
                    grid[r_up][c_left],   // neighbor 7
                    grid[r_up][c],        // neighbor 6
                    grid[r_up][c_right],  // neighbor 5
                    grid[r][c_left],      // neighbor 4
                    grid[r][c_right],     // neighbor 3
                    grid[r_down][c_left], // neighbor 2
                    grid[r_down][c],      // neighbor 1
                    grid[r_down][c_right] // neighbor 0
                };

                // Compute neighbor count via popcount
                wire [3:0] neighbor_count;
                assign neighbor_count = popcount8(neighbors_bits);

                // Apply game rules:
                // 0-1 neighbor: dead (0)
                // 2 neighbors: no change
                // 3 neighbors: alive (1)
                // 4+ neighbors: dead (0)
                assign next_grid[r][c] = (neighbor_count <= 1) ? 1'b0 :
                                        (neighbor_count == 2) ? grid[r][c] :
                                        (neighbor_count == 3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Flatten next_grid 2D array into a 256-bit vector
    wire [255:0] next_q;
    generate
        for (r = 0; r < N; r = r + 1) begin : FLATTEN_ROW
            for (c = 0; c < N; c = c + 1) begin : FLATTEN_COL
                assign next_q[r*16 + c] = next_grid[r][c];
            end
        end
    endgenerate

    // Sequential logic: synchronous load or update
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule