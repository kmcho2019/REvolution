module TopModule(
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Internal 2D grid representation as wire arrays for next state calculation
    wire [0:HEIGHT-1][0:WIDTH-1] current_grid;
    wire [0:HEIGHT-1][0:WIDTH-1] next_grid;

    genvar r, c;

    // Flatten current q into 2D array view
    // q[15:0] is row 0, q[31:16] is row 1, etc.
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : UNPACK_ROW
            for (c = 0; c < WIDTH; c = c + 1) begin : UNPACK_COL
                assign current_grid[r][c] = q[r*WIDTH + c];
            end
        end
    endgenerate

    // Wrap index modulo 16 (0 to 15) by masking 4 LSBs
    function automatic [3:0] wrap_index(input integer idx);
        wrap_index = idx[3:0]; // idx mod 16
    endfunction

    // Function to count neighbors of a cell at (row,col)
    function automatic [3:0] count_neighbors(
        input integer row,
        input integer col
    );
        integer dr, dc;
        integer nr, nc;
        integer sum;
    begin
        sum = 0;
        for (dr = -1; dr <= 1; dr = dr + 1) begin
            for (dc = -1; dc <= 1; dc = dc + 1) begin
                if (!(dr == 0 && dc == 0)) begin
                    nr = wrap_index(row + dr);
                    nc = wrap_index(col + dc);
                    sum = sum + current_grid[nr][nc];
                end
            end
        end
        count_neighbors = sum[3:0];
    end
    endfunction

    // Compute next state for each cell using assign and generate
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : NEXT_ROW
            for (c = 0; c < WIDTH; c = c + 1) begin : NEXT_COL
                wire [3:0] nbr_cnt = count_neighbors(r, c);
                wire cell_current = current_grid[r][c];

                // Apply rules combinationally using assign
                assign next_grid[r][c] = (nbr_cnt <= 1) ? 1'b0 :
                                         (nbr_cnt == 2) ? cell_current :
                                         (nbr_cnt == 3) ? 1'b1 :
                                         1'b0;
            end
        end
    endgenerate

    // Flatten next_grid 2D array back to 256-bit vector for sequential update
    wire [255:0] next_q_flat;
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : FLATTEN_ROW
            for (c = 0; c < WIDTH; c = c + 1) begin : FLATTEN_COL
                assign next_q_flat[r*WIDTH + c] = next_grid[r][c];
            end
        end
    endgenerate

    // Sequential logic: on clk posedge, load or update q
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q_flat;
    end

endmodule