module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam SIZE = 16;
    localparam MASK = SIZE - 1;

    // Represent current state as 2D array for readability
    wire [SIZE-1:0] curr_grid [SIZE-1:0];
    genvar r, c;
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : CONV_CURR_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : CONV_CURR_COL
                assign curr_grid[r][c] = q[r*SIZE + c];
            end
        end
    endgenerate

    // Neighbor count per cell using balanced adder tree for better timing
    wire [3:0] neighbor_count [SIZE-1:0][SIZE-1:0];
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : GEN_ROW
            // Precompute wrapped row indices for neighbor access
            localparam integer r_up   = (r == 0) ? MASK : r - 1;
            localparam integer r_down = (r == MASK) ? 0 : r + 1;
            for (c = 0; c < SIZE; c = c + 1) begin : GEN_COL
                // Precompute wrapped column indices
                localparam integer c_left  = (c == 0) ? MASK : c - 1;
                localparam integer c_right = (c == MASK) ? 0 : c + 1;

                // Access neighbors explicitly
                wire n0 = curr_grid[r_up][c_left];
                wire n1 = curr_grid[r_up][c];
                wire n2 = curr_grid[r_up][c_right];
                wire n3 = curr_grid[r][c_left];
                wire n4 = curr_grid[r][c_right];
                wire n5 = curr_grid[r_down][c_left];
                wire n6 = curr_grid[r_down][c];
                wire n7 = curr_grid[r_down][c_right];

                // Balanced adder tree summation of neighbors
                wire [1:0] sum0 = n0 + n1;
                wire [1:0] sum1 = n2 + n3;
                wire [1:0] sum2 = n4 + n5;
                wire [1:0] sum3 = n6 + n7;

                wire [2:0] sum01 = sum0 + sum1;
                wire [2:0] sum23 = sum2 + sum3;

                wire [3:0] total = sum01 + sum23;

                assign neighbor_count[r][c] = total;
            end
        end
    endgenerate

    // Compute next state for each cell according to rules
    wire next_grid [SIZE-1:0][SIZE-1:0];
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : NEXT_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : NEXT_COL
                // Rule:
                // 0-1 neighbors: cell = 0
                // 2 neighbors: cell unchanged
                // 3 neighbors: cell = 1
                // 4+ neighbors: cell = 0
                assign next_grid[r][c] = (neighbor_count[r][c] == 4'd3) ? 1'b1 :
                                         (neighbor_count[r][c] == 4'd2) ? curr_grid[r][c] :
                                         1'b0;
            end
        end
    endgenerate

    // Flatten next_grid to 1D vector for register update
    wire [255:0] next_state;
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : FLATTEN_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : FLATTEN_COL
                assign next_state[r*SIZE + c] = next_grid[r][c];
            end
        end
    endgenerate

    // Sequential update: load or advance state every clock edge
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule