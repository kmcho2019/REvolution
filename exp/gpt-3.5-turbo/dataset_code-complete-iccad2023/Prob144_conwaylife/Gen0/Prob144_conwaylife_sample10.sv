module GameOfLife (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  reg [15:0][15:0] grid;
  reg [15:0][15:0] next_grid;
  
  integer i, j, neighbors;
  
  // Load initial state
  always @(posedge clk) begin
    if (load) begin
      for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
          grid[i][j] <= data[(i*16) + j];
        end
      end
    end
  end

  // Calculate next state of the game
  always @(posedge clk) begin
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        // Calculate number of neighbors
        neighbors = grid[i][((j+1) % 16)] + grid[((i+1) % 16)][((j+1) % 16)] +
                    grid[((i+1) % 16)][j] + grid[((i+1) % 16)][((j-1+16) % 16)] +
                    grid[i][((j-1+16) % 16)] + grid[((i-1+16) % 16)][((j-1+16) % 16)] +
                    grid[((i-1+16) % 16)][j] + grid[((i-1+16) % 16)][((j+1) % 16)];
                    
        // Apply rules to determine next state
        if (neighbors <= 1) begin
          next_grid[i][j] <= 0;
        end
        else if (neighbors == 2) begin
          next_grid[i][j] <= grid[i][j];
        end
        else if (neighbors == 3) begin
          next_grid[i][j] <= 1;
        end
        else begin
          next_grid[i][j] <= 0;
        end
      end
    end
    
    // Update grid with next state
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        grid[i][j] <= next_grid[i][j];
      end
    end
    
    // Assign grid to output q
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        q[(i*16) + j] <= grid[i][j];
      end
    end
  end

endmodule