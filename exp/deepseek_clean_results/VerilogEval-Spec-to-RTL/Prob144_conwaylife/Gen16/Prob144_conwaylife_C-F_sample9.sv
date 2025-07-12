module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // 2D array representation for better readability
    reg [15:0] grid [15:0];
    wire [15:0] next_grid [15:0];
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                // Efficient toroidal wrapping using bitwise masking
                wire [3:0] row_prev = (i-1) & 15;
                wire [3:0] row_next = (i+1) & 15;
                wire [3:0] col_prev = (j-1) & 15;
                wire [3:0] col_next = (j+1) & 15;
                
                // Access neighbors through 2D array
                wire n0 = grid[row_prev][col_prev];
                wire n1 = grid[row_prev][j];
                wire n2 = grid[row_prev][col_next];
                wire n3 = grid[i][col_prev];
                wire n4 = grid[i][col_next];
                wire n5 = grid[row_next][col_prev];
                wire n6 = grid[row_next][j];
                wire n7 = grid[row_next][col_next];
                
                // Optimized neighbor counting with carry-save
                wire [1:0] sum_a = n0 + n1 + n2; // Top row
                wire [1:0] sum_b = n3 + n4;      // Middle row
                wire [1:0] sum_c = n5 + n6 + n7; // Bottom row
                wire [3:0] neighbor_count = sum_a + sum_b + sum_c;
                
                // Priority-encoded state update with stability detection
                wire current = grid[i][j];
                wire next_state = (neighbor_count == 3) ? 1'b1 :
                                 (neighbor_count == 2) ? current :
                                 1'b0;
                assign next_grid[i][j] = next_state;
            end
        end
    endgenerate

    // Update logic with conditional writes
    always @(posedge clk) begin
        if (load) begin
            // Load initial data
            for (integer k = 0; k < 16; k = k + 1) begin
                grid[k] <= data[k*16 +: 16];
            end
        end else begin
            // Only update cells that will change
            for (integer i = 0; i < 16; i = i + 1) begin
                for (integer j = 0; j < 16; j = j + 1) begin
                    if (next_grid[i][j] !== grid[i][j]) begin
                        grid[i][j] <= next_grid[i][j];
                    end
                end
            end
        end
    end

    // Output mapping
    always @(*) begin
        for (integer k = 0; k < 16; k = k + 1) begin
            q[k*16 +: 16] = grid[k];
        end
    end

endmodule