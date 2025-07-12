module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Parameters for clarity
    localparam N = 16;

    // Convert q into 2D array for easier indexing
    wire [0:0] grid [0:N-1][0:N-1];
    genvar r, c;
    generate
        for (r = 0; r < N; r = r + 1) begin : ROWS
            for (c = 0; c < N; c = c + 1) begin : COLS
                assign grid[r][c] = q[r*16 + c];
            end
        end
    endgenerate

    // Calculate neighbors and next state per cell
    wire [0:0] next_grid [0:N-1][0:N-1];

    // Function to wrap index for toroidal behavior
    function automatic integer wrap_index;
        input integer idx;
        begin
            if (idx < 0)
                wrap_index = idx + N;
            else if (idx >= N)
                wrap_index = idx - N;
            else
                wrap_index = idx;
        end
    endfunction

    generate
        for (r = 0; r < N; r = r + 1) begin : CALC_ROW
            for (c = 0; c < N; c = c + 1) begin : CALC_COL
                // Compute neighbor indices with wrapping
                // Precompute neighbor positions
                localparam int r_up = (r == 0) ? N-1 : r-1;
                localparam int r_down = (r == N-1) ? 0 : r+1;
                localparam int c_left = (c == 0) ? N-1 : c-1;
                localparam int c_right = (c == N-1) ? 0 : c+1;

                // Sum the 8 neighbors
                wire [3:0] neighbors_sum;
                assign neighbors_sum =
                    grid[r_up][c_left] + grid[r_up][c] + grid[r_up][c_right] +
                    grid[r][c_left]               + grid[r][c_right] +
                    grid[r_down][c_left] + grid[r_down][c] + grid[r_down][c_right];

                // Apply the rules combinationally
                assign next_grid[r][c] = 
                    (neighbors_sum <= 1) ? 1'b0 :
                    (neighbors_sum == 2) ? grid[r][c] :
                    (neighbors_sum == 3) ? 1'b1 :
                    1'b0;
            end
        end
    endgenerate

    // Flatten next_grid to 1D vector
    wire [255:0] next_state;
    generate
        for (r = 0; r < N; r = r + 1) begin : FLATTEN_ROW
            for (c = 0; c < N; c = c + 1) begin : FLATTEN_COL
                assign next_state[r*16 + c] = next_grid[r][c];
            end
        end
    endgenerate

    // Sequential logic: load or update q each clock
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule