module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Current state grid (16x16)
    reg [15:0] grid [0:15];
    
    // Next state grid (16x16)
    reg [15:0] next_grid [0:15];
    
    integer i, j;
    integer row, col;
    integer neighbor_count;
    
    // Functions to handle toroidal wrapping
    function integer wrap_row;
        input integer r;
        begin
            wrap_row = (r + 16) % 16;
        end
    endfunction
    
    function integer wrap_col;
        input integer c;
        begin
            wrap_col = (c + 16) % 16;
        end
    endfunction
    
    always @(posedge clk) begin
        if (load) begin
            // Load initial state
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= data[i*16 +: 16];
            end
        end else begin
            // Update to next state
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= next_grid[i];
            end
        end
    end
    
    always @(*) begin
        // Calculate next state for each cell
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Count neighbors (8 surrounding cells)
                neighbor_count = 0;
                
                // Check all 8 possible neighbors
                for (row = i-1; row <= i+1; row = row + 1) begin
                    for (col = j-1; col <= j+1; col = col + 1) begin
                        // Skip the cell itself
                        if (!(row == i && col == j)) begin
                            if (grid[wrap_row(row)][wrap_col(col)]) begin
                                neighbor_count = neighbor_count + 1;
                            end
                        end
                    end
                end
                
                // Apply game rules
                case (neighbor_count)
                    0, 1: next_grid[i][j] = 1'b0;    // Die from underpopulation
                    2:    next_grid[i][j] = grid[i][j]; // Stay the same
                    3:    next_grid[i][j] = 1'b1;     // Birth or survival
                    default: next_grid[i][j] = 1'b0;  // Die from overpopulation
                endcase
            end
        end
    end
    
    // Convert grid to output vector
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            q[i*16 +: 16] = grid[i];
        end
    end

endmodule