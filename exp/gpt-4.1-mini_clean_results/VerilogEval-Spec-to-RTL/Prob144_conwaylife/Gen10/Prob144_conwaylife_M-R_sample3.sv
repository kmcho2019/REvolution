module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = 4'hF;

    // State stored as 2D register array for clarity: state[row][col]
    reg state [0:SIZE-1][0:SIZE-1];
    reg next_state [0:SIZE-1][0:SIZE-1];

    integer i, j;

    // Function to compute neighbor count with wrapping
    function [3:0] count_neighbors;
        input integer row;
        input integer col;
        integer dr, dc;
        integer r_idx, c_idx;
        reg [3:0] count;
    begin
        count = 0;
        for (dr = -1; dr <= 1; dr = dr + 1) begin
            for (dc = -1; dc <= 1; dc = dc + 1) begin
                if (!(dr == 0 && dc == 0)) begin
                    // wrap around indices
                    r_idx = (row + dr) & MASK;
                    c_idx = (col + dc) & MASK;
                    count = count + state[r_idx][c_idx];
                end
            end
        end
        count_neighbors = count;
    end
    endfunction

    // Initialize state from input data on load, and compute next state combinationally
    always @(*) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            for (j = 0; j < SIZE; j = j + 1) begin
                // Compute next state based on rules
                reg [3:0] ncount;
                ncount = count_neighbors(i, j);
                case (ncount)
                    4'd0, 4'd1: next_state[i][j] = 1'b0;             // 0-1 neighbor: dead
                    4'd2:       next_state[i][j] = state[i][j];      // 2 neighbors: stays same
                    4'd3:       next_state[i][j] = 1'b1;             // 3 neighbors: alive
                    default:    next_state[i][j] = 1'b0;             // 4+ neighbors: dead
                endcase
            end
        end
    end

    // On clock edge, either load new data or update state
    always @(posedge clk) begin
        if (load) begin
            // Load input data into state array (map from 256-bit vector)
            for (i = 0; i < SIZE; i = i + 1) begin
                for (j = 0; j < SIZE; j = j + 1) begin
                    state[i][j] <= data[i*SIZE + j];
                end
            end
        end else begin
            // Update to next state
            for (i = 0; i < SIZE; i = i + 1) begin
                for (j = 0; j < SIZE; j = j + 1) begin
                    state[i][j] <= next_state[i][j];
                end
            end
        end
    end

    // Flatten 2D state array to output vector q
    always @(*) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            for (j = 0; j < SIZE; j = j + 1) begin
                q[i*SIZE + j] = state[i][j];
            end
        end
    end

endmodule