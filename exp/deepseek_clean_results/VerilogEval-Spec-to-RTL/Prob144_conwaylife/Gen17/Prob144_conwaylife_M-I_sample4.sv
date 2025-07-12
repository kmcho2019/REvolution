module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Stage 1: Precompute row sums
    reg [255:0] q_reg;
    wire [15:0][15:0] cell_grid;
    wire [15:0][2:0] row_sums [15:0]; // Sum of left, center, right columns per row
    
    // Grid mapping
    generate
        for (genvar i = 0; i < 16; i++) begin
            assign cell_grid[i] = q_reg[i*16 +: 16];
        end
    endgenerate

    // Precompute row sums (shared between cells)
    generate
        for (genvar row = 0; row < 16; row++) begin
            for (genvar col = 0; col < 16; col++) begin
                localparam left_col = (col - 1) & 15;
                localparam right_col = (col + 1) & 15;
                assign row_sums[row][col] = 
                    cell_grid[row][left_col] + cell_grid[row][col] + cell_grid[row][right_col];
            end
        end
    endgenerate

    // Stage 2: Neighbor counting (pipelined)
    reg [255:0][3:0] neighbor_count;
    reg [255:0] next_q;
    wire [15:0] row_enable; // Row-level enable signals

    always @(posedge clk) begin
        // Pipeline stage 1: Store current state
        q_reg <= load ? data : q;
        
        // Pipeline stage 2: Calculate neighbor counts and next state
        for (int row = 0; row < 16; row++) begin
            for (int col = 0; col < 16; col++) begin
                localparam prev_row = (row - 1) & 15;
                localparam next_row = (row + 1) & 15;
                
                // Sum of three rows (optimized carry-lookahead)
                wire [3:0] total = row_sums[prev_row][col] + 
                                   row_sums[row][col] - cell_grid[row][col] + 
                                   row_sums[next_row][col];
                
                neighbor_count[row*16 + col] <= total;
                
                // Next state logic
                case (total)
                    4'd2: next_q[row*16 + col] <= q_reg[row*16 + col];
                    4'd3: next_q[row*16 + col] <= 1'b1;
                    default: next_q[row*16 + col] <= 1'b0;
                endcase
            end
            
            // Row enable - if any cell in row needs update
            row_enable[row] <= |(neighbor_count[row*16 +: 16] != {16{4'd2}});
        end
    end

    // Final update with hierarchical clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (int row = 0; row < 16; row++) begin
                if (row_enable[row]) begin
                    for (int col = 0; col < 16; col++) begin
                        if (neighbor_count[row*16 + col] != 4'd2) begin
                            q[row*16 + col] <= next_q[row*16 + col];
                        end
                    end
                end
            end
        end
    end

endmodule