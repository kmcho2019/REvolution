module TopModule (
    input               clk,
    input               load,
    input  [255:0]      data,
    output reg [255:0]  q
);
    localparam N = 16;                  // Grid dimension (rows and cols)
    localparam IDX_MASK = 4'hF;        // Mask for modulo 16 wrap-around

    // Create 2D wire array view of current grid state 'q'
    wire grid [0:N-1][0:N-1];
    genvar r, c;
    generate
        for (r = 0; r < N; r = r + 1) begin : GEN_GRID_ROW
            for (c = 0; c < N; c = c + 1) begin : GEN_GRID_COL
                // Use shift for multiplication by 16 instead of *
                assign grid[r][c] = q[(r << 4) + c];
            end
        end
    endgenerate

    // Wire array for next grid state
    wire next_grid [0:N-1][0:N-1];

    // Balanced adder function for summing 8 bits
    function [3:0] sum8;
        input [7:0] bits;
        reg [2:0] s03; // sum of bits[0..3]
        reg [2:0] s47; // sum of bits[4..7]
        begin
            s03 = bits[0] + bits[1] + bits[2] + bits[3];
            s47 = bits[4] + bits[5] + bits[6] + bits[7];
            sum8 = s03 + s47;
        end
    endfunction

    generate
        for (r = 0; r < N; r = r + 1) begin : GEN_NEXT_ROW
            for (c = 0; c < N; c = c + 1) begin : GEN_NEXT_COL
                wire [7:0] neighbors_bits;

                // Explicit neighbor indexing with wrap-around via bitmasking
                assign neighbors_bits[0] = grid[(r + N - 1) & IDX_MASK][(c + N - 1) & IDX_MASK];
                assign neighbors_bits[1] = grid[(r + N - 1) & IDX_MASK][c               & IDX_MASK];
                assign neighbors_bits[2] = grid[(r + N - 1) & IDX_MASK][(c + 1)         & IDX_MASK];
                assign neighbors_bits[3] = grid[r               & IDX_MASK][(c + N - 1) & IDX_MASK];
                assign neighbors_bits[4] = grid[r               & IDX_MASK][(c + 1)     & IDX_MASK];
                assign neighbors_bits[5] = grid[(r + 1)       & IDX_MASK][(c + N - 1) & IDX_MASK];
                assign neighbors_bits[6] = grid[(r + 1)       & IDX_MASK][c           & IDX_MASK];
                assign neighbors_bits[7] = grid[(r + 1)       & IDX_MASK][(c + 1)     & IDX_MASK];

                wire [3:0] neighbors_sum = sum8(neighbors_bits);

                wire curr_cell = grid[r][c];

                // Apply rules: 0-1 => 0, 2 => curr, 3 => 1, 4+ => 0
                assign next_grid[r][c] = (neighbors_sum <= 1) ? 1'b0 :
                                         (neighbors_sum == 2) ? curr_cell :
                                         (neighbors_sum == 3) ? 1'b1 :
                                         1'b0;
            end
        end
    endgenerate

    // Flatten next_grid 2D array to 256-bit vector
    wire [255:0] next_q;
    generate
        for (r = 0; r < N; r = r + 1) begin : GEN_FLATTEN_ROW
            for (c = 0; c < N; c = c + 1) begin : GEN_FLATTEN_COL
                assign next_q[(r << 4) + c] = next_grid[r][c];
            end
        end
    endgenerate

    // Sequential load or update on posedge clk
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule