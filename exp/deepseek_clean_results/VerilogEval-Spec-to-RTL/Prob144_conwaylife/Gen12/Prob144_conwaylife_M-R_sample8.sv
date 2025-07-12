module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Represent grid as 2D array for cleaner indexing
    wire [15:0] grid [0:15];
    
    // Flatten the 2D array to output
    integer i;
    always @* begin
        for (i = 0; i < 16; i = i + 1)
            q[i*16 +: 16] = grid[i];
    end

    // Next state calculation
    reg [255:0] next_q;
    always @* begin
        for (integer row = 0; row < 16; row = row + 1) begin
            for (integer col = 0; col < 16; col = col + 1) begin
                // Calculate neighbor positions with wrap-around
                integer row_p = (row + 15) & 15; // row-1
                integer row_n = (row + 1) & 15;  // row+1
                integer col_p = (col + 15) & 15;  // col-1
                integer col_n = (col + 1) & 15;   // col+1
                
                // Count live neighbors
                reg [3:0] count;
                count = grid[row_p][col_p] + grid[row_p][col] + grid[row_p][col_n] +
                        grid[row][col_p]   +                   grid[row][col_n] +
                        grid[row_n][col_p] + grid[row_n][col] + grid[row_n][col_n];
                
                // Determine next state
                case (count)
                    2: next_q[row*16 + col] = grid[row][col]; // no change
                    3: next_q[row*16 + col] = 1'b1;           // alive
                    default: next_q[row*16 + col] = 1'b0;      // dead
                endcase
            end
        end
    end

    // Update state
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < 16; i = i + 1)
                grid[i] <= data[i*16 +: 16];
        end else begin
            for (i = 0; i < 16; i = i + 1)
                grid[i] <= next_q[i*16 +: 16];
        end
    end

endmodule