module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to calculate wrapped index (toroidal)
    function [3:0] wrap;
        input [3:0] idx;
        begin
            wrap = idx;  // Default case (no wrapping needed)
            if (idx == 4'b1111) wrap = 4'b0000;  // 15 wraps to 0
            else if (idx == 4'b0000) wrap = 4'b1111;  // 0 wraps to 15
        end
    endfunction

    // Represent grid as 2D array
    reg [15:0] grid [0:15];
    wire [15:0] next_grid [0:15];
    integer row, col, i, j;

    // Convert between 1D and 2D representations
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            grid[i] = q[i*16 +: 16];
        end
    end

    // Calculate next state
    always @(*) begin
        for (row = 0; row < 16; row = row + 1) begin
            for (col = 0; col < 16; col = col + 1) begin
                // Count live neighbors with wrapping
                reg [3:0] count = 0;
                for (i = -1; i <= 1; i = i + 1) begin
                    for (j = -1; j <= 1; j = j + 1) begin
                        if (i == 0 && j == 0) continue;  // Skip self
                        count = count + grid[wrap(row + i)][wrap(col + j)];
                    end
                end

                // Apply game rules
                case (count)
                    3: next_grid[row][col] = 1'b1;
                    2: next_grid[row][col] = grid[row][col];
                    default: next_grid[row][col] = 1'b0;
                endcase
            end
        end
    end

    // Convert back to 1D and update state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                q[i*16 +: 16] <= next_grid[i];
            end
        end
    end

endmodule