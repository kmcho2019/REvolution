module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Shift register representation for efficient neighbor access
    reg [15:0] grid [15:0];
    wire [15:0] next_grid [15:0];
    
    // Circular shift operations for neighbor access
    function [15:0] shift_left(input [15:0] row);
        shift_left = {row[14:0], row[15]};
    endfunction
    
    function [15:0] shift_right(input [15:0] row);
        shift_right = {row[0], row[15:1]};
    endfunction
    
    // Neighbor counting pipeline
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                // Get current row and shifted versions
                wire [15:0] curr_row = grid[i];
                wire [15:0] left_row = grid[(i-1) & 15];
                wire [15:0] right_row = grid[(i+1) & 15];
                
                // Get column positions with wrap-around
                wire left_col = curr_row[(j-1) & 15];
                wire right_col = curr_row[(j+1) & 15];
                
                // Count horizontal neighbors (3 per row)
                wire [1:0] left_row_count = left_row[(j-1) & 15] + left_row[j] + left_row[(j+1) & 15];
                wire [1:0] curr_row_count = left_col + right_col; // center cell excluded
                wire [1:0] right_row_count = right_row[(j-1) & 15] + right_row[j] + right_row[(j+1) & 15];
                
                // Carry-save adder for total count
                wire [2:0] temp_sum = left_row_count + curr_row_count;
                wire [3:0] total_count = temp_sum + right_row_count;
                
                // Next state logic
                wire current = curr_row[j];
                wire stable = (total_count == 2) & current;
                wire birth = (total_count == 3);
                assign next_grid[i][j] = stable ? current : birth;
            end
        end
    endgenerate

    // Update logic with clock gating
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