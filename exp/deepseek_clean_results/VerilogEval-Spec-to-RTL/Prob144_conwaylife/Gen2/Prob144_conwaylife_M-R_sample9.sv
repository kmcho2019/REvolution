module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Represent grid as 2D array for clarity
    wire [15:0] grid [0:15];
    wire [15:0] next_grid [0:15];
    
    // Flatten the grid for output
    integer i;
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            q[i*16 +: 16] = grid[i];
        end
    end

    // Combinational next state calculation
    always @(*) begin
        for (int row = 0; row < 16; row = row + 1) begin
            for (int col = 0; col < 16; col = col + 1) begin
                // Calculate neighbor count with wrap-around
                reg [3:0] count = 0;
                
                // Check all 8 neighbors with modular arithmetic
                count = count + grid[(row+15)%16][(col+15)%16]; // top-left
                count = count + grid[(row+15)%16][col];         // top
                count = count + grid[(row+15)%16][(col+1)%16];  // top-right
                count = count + grid[row][(col+15)%16];          // left
                count = count + grid[row][(col+1)%16];           // right
                count = count + grid[(row+1)%16][(col+15)%16];   // bottom-left
                count = count + grid[(row+1)%16][col];           // bottom
                count = count + grid[(row+1)%16][(col+1)%16];    // bottom-right
                
                // Apply game rules
                case (count)
                    2: next_grid[row][col] = grid[row][col]; // no change
                    3: next_grid[row][col] = 1'b1;           // become alive
                    default: next_grid[row][col] = 1'b0;     // die
                endcase
            end
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= data[i*16 +: 16];
            end
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= next_grid[i];
            end
        end
    end

endmodule