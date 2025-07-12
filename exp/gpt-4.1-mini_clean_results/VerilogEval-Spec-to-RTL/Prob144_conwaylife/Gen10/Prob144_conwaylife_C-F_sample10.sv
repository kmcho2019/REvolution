module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [255:0] data,
    output reg  [255:0] q
);
    localparam N = 16; // Grid dimension
    localparam N_MASK = 4'hF; // For modulo-16 by bit masking

    // 2D combinational view of current grid state
    wire grid [0:N-1][0:N-1];
    genvar r, c;
    generate
        for (r = 0; r < N; r = r + 1) begin: ROWS
            for (c = 0; c < N; c = c + 1) begin: COLS
                assign grid[r][c] = q[r*N + c];
            end
        end
    endgenerate

    // Helper combinational function: popcount of 8 bits using a simple adder tree
    // implemented as pure combinational logic with wires.
    function [3:0] popcount8;
        input [7:0] bits;
        reg [3:0] sum1, sum2;
        begin
            // Sum bits in pairs: 4 x 2 bits
            sum1 = (bits[0] + bits[1]) + (bits[2] + bits[3]);
            sum2 = (bits[4] + bits[5]) + (bits[6] + bits[7]);
            popcount8 = sum1 + sum2;
        end
    endfunction

    // Predefined neighbor relative offsets, excluding (0,0)
    localparam signed [3:0] nbr_offs_r [0:7] = '{-1, -1, -1, 0, 0, 1, 1, 1};
    localparam signed [3:0] nbr_offs_c [0:7] = '{-1,  0,  1,-1, 1,-1, 0, 1};

    // Next state wire grid
    wire next_grid [0:N-1][0:N-1];

    generate
        for (r = 0; r < N; r = r + 1) begin: CALC_ROW
            for (c = 0; c < N; c = c + 1) begin: CALC_COL
                // Wrap current cell indices using localparams to avoid arithmetic in index expression
                localparam int R = r;
                localparam int C = c;

                // Collect neighbors bits into a vector for popcount
                wire [7:0] neighbors_bits;
                genvar i;
                for (i = 0; i < 8; i = i + 1) begin: NEIGHBORS
                    // Calculate wrapped neighbor row and col indices with bit masking for modulo 16
                    wire [3:0] nr = (R + nbr_offs_r[i] + N) & N_MASK;
                    wire [3:0] nc = (C + nbr_offs_c[i] + N) & N_MASK;
                    assign neighbors_bits[i] = grid[nr][nc];
                end

                wire [3:0] neighbors_sum = popcount8(neighbors_bits);
                wire current_cell = grid[R][C];

                // Apply the rules:
                // (1) 0-1 neighbor: 0
                // (2) 2 neighbors: same state
                // (3) 3 neighbors: 1
                // (4) 4+ neighbors: 0
                assign next_grid[R][C] = (neighbors_sum <= 1) ? 1'b0 :
                                         (neighbors_sum == 2) ? current_cell :
                                         (neighbors_sum == 3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Flatten next_grid into next_q vector
    wire [255:0] next_q;
    generate
        for (r = 0; r < N; r = r + 1) begin: FLATTEN_ROW
            for (c = 0; c < N; c = c + 1) begin: FLATTEN_COL
                assign next_q[r*N + c] = next_grid[r][c];
            end
        end
    endgenerate

    // Sequential state update with synchronous load
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule