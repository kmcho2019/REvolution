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

    // Neighbor counts per cell (0 to 8 fits in 4 bits)
    wire [3:0] neighbor_count [SIZE-1:0][SIZE-1:0];

    generate
        for (r = 0; r < SIZE; r = r + 1) begin : GEN_ROW
            // Precompute wrapped indices for neighbors in row dimension
            localparam integer r_up   = (r == 0) ? MASK : r - 1;
            localparam integer r_down = (r == MASK) ? 0 : r + 1;
            for (c = 0; c < SIZE; c = c + 1) begin : GEN_COL
                // Precompute wrapped indices for neighbors in col dimension
                localparam integer c_left  = (c == 0) ? MASK : c - 1;
                localparam integer c_right = (c == MASK) ? 0 : c + 1;

                // Reference the eight neighbors directly
                wire n0 = q_rows[r_up][c_left];
                wire n1 = q_rows[r_up][c];
                wire n2 = q_rows[r_up][c_right];
                wire n3 = q_rows[r][c_left];
                wire n4 = q_rows[r][c_right];
                wire n5 = q_rows[r_down][c_left];
                wire n6 = q_rows[r_down][c];
                wire n7 = q_rows[r_down][c_right];

                // Balanced adder tree for neighbor count
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

    // Next state per cell according to rules
    wire next_state [SIZE-1:0][SIZE-1:0];
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : NEXT_ROW
            for (c = 0; c < SIZE; c = c + 1) begin : NEXT_COL
                // Apply rules:
                // 0-1 neighbors: 0
                // 2 neighbors: no change
                // 3 neighbors: 1
                // 4+ neighbors: 0
                assign next_state[r][c] = (neighbor_count[r][c] == 4'd3) ? 1'b1 :
                                         (neighbor_count[r][c] == 4'd2) ? q_rows[r][c] : 1'b0;
            end
        end
    endgenerate

    // Flatten next_state to vector
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