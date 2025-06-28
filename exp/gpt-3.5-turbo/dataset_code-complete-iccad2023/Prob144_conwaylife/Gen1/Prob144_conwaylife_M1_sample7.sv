module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  reg [17:0] grid [17:0]; // Create an 18x18 grid for toroid wrap-around
  
  always @(posedge clk) begin
    if (load) begin
      // Load initial state
      for (int i = 0; i < 18; i = i + 1) begin
        grid[i] <= data[(i+1)*16 - 1 : i*16];
      end
    end else begin
      // Update cell state
      for (int i = 0; i < 16; i = i + 1) begin
        for (int j = 0; j < 16; j = j + 1) begin
          int alive_neighbors = 0;
          foreach (grid[i-1][j-1], grid[i-1][j], grid[i-1][j+1],
                   grid[i][j-1],                 grid[i][j+1],
                   grid[i+1][j-1], grid[i+1][j], grid[i+1][j+1]) begin
            alive_neighbors += item;
          end
          
          if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
            q[i*16 + j] <= 0; // Cell becomes 0
          end else if (alive_neighbors == 3) begin
            q[i*16 + j] <= 1; // Cell becomes 1
          end
        end
      end
      
      // Update toroid wrap-around separately
      for (int i = 0; i < 16; i = i + 1) begin
        grid[i][16] <= grid[i][0]; // Wrap around right edge
        grid[i][17] <= grid[i][1]; // Wrap around right edge
        grid[16][i] <= grid[0][i]; // Wrap around bottom edge
        grid[17][i] <= grid[1][i]; // Wrap around bottom edge
      end
    end
  end

endmodule