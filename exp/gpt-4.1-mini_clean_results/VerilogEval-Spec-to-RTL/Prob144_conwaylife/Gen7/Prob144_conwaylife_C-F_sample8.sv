module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16; // Grid dimension

    // 2D wire array view of current state q for combinational logic
    wire grid [0:N-1][0:N-1];
    genvar r, c;
    generate
        for (r = 0; r < N; r = r + 1) begin: ROWS
            for (c = 0; c < N; c = c + 1) begin: COLS
                assign grid[r][c] = q[r*16 + c];
            end
        end
    endgenerate

    // Next state bits for all cells - wire array
    wire next_grid [0:N-1][0:N-1];

    generate
        for (r = 0; r < N; r = r + 1) begin: CALC_ROW
            for (c = 0; c < N; c = c + 1) begin: CALC_COL
                // Wrap indices explicitly using localparams (avoid runtime arithmetic)
                localparam int r_up    = (r == 0)    ? N-1 : r-1;
                localparam int r_down  = (r == N-1)  ? 0   : r+1;
                localparam int c_left  = (c == 0)    ? N-1 : c-1;
                localparam int c_right = (c == N-1)  ? 0   : c+1;

                // Sum neighbors: 8 adjacent cells around (r,c)
                wire [3:0] neighbors_sum;
                assign neighbors_sum =
                      grid[r_up][c_left] + grid[r_up][c] + grid[r_up][c_right]
                    + grid[r][c_left]                 + grid[r][c_right]
                    + grid[r_down][c_left] + grid[r_down][c] + grid[r_down][c_right];

                // Apply Game of Life rules
                assign next_grid[r][c] = (neighbors_sum <= 1) ? 1'b0 :
                                        (neighbors_sum == 2) ? grid[r][c] :
                                        (neighbors_sum == 3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Flatten next_grid 2D wire array into 256-bit wire vector
    wire [255:0] next_q;
    generate
        for (r = 0; r < N; r = r + 1) begin: FLATTEN_ROW
            for (c = 0; c < N; c = c + 1) begin: FLATTEN_COL
                assign next_q[r*16 + c] = next_grid[r][c];
            end
        end
    endgenerate

    // Sequential logic: load or update state on clock rising edge
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule