module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    wire [255:0] row_sums [0:15];  // Row sums for neighbor sharing
    
    // Precompute row sums for neighbor sharing
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_sum
            for (col = 0; col < 16; col = col + 1) begin : col_sum
                // Calculate adjacent rows with wrap-around
                wire [3:0] prev_row = (row == 0) ? 15 : (row - 1);
                wire [3:0] next_row = (row == 15) ? 0 : (row + 1);
                
                // Get neighbor cells in same column
                wire top = q[{prev_row, col[3:0]}];
                wire bottom = q[{next_row, col[3:0]}];
                
                // Calculate row sums (top + current + bottom)
                assign row_sums[row][col] = top + q[{row[3:0], col[3:0]}] + bottom;
            end
        end
    endgenerate

    // Stage 1: Calculate neighbor counts
    reg [255:0] neighbor_counts;
    always @(*) begin
        for (integer row = 0; row < 16; row = row + 1) begin
            for (integer col = 0; col < 16; col = col + 1) begin
                // Get adjacent columns with wrap-around
                integer prev_col = (col == 0) ? 15 : (col - 1);
                integer next_col = (col == 15) ? 0 : (col + 1);
                
                // Sum of left, center, right columns (using precomputed row sums)
                integer left_sum = row_sums[row][prev_col];
                integer right_sum = row_sums[row][next_col];
                
                // Final count (subtract self from center sum)
                neighbor_counts[row*16 + col] = left_sum + right_sum + 
                                             (row_sums[row][col] - q[{row[3:0], col[3:0]}]);
            end
        end
    end

    // Stage 2: Calculate next state with dynamic stability detection
    always @(*) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            case (neighbor_counts[i])
                2: next_q[i] = q[i];  // Stable
                3: next_q[i] = 1'b1;  // Birth
                default: next_q[i] = 1'b0;  // Death
            endcase
        end
    end

    // Sequential update with optimized clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Only update cells that will change state
            for (integer i = 0; i < 256; i = i + 1) begin
                if (next_q[i] !== q[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule