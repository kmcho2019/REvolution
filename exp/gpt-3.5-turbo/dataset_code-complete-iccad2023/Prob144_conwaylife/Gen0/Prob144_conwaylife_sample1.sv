module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

// Create a 16x16 array representing the grid
reg [15:0] [15:0] grid;

// Calculate the number of neighbors for a given cell
function integer count_neighbors;
  input integer x, y; // Coordinates of the cell
  integer count;
  begin
    count = grid[(x+15) % 16][(y+15) % 16] + 
            grid[(x+15) % 16][y] + 
            grid[(x+15) % 16][(y+1) % 16] + 
            grid[x][(y+15) % 16] + 
            grid[x][(y+1) % 16] + 
            grid[(x+1) % 16][(y+15) % 16] + 
            grid[(x+1) % 16][y] + 
            grid[(x+1) % 16][(y+1) % 16];
    count_neighbors = count;
  end
endfunction

always @(posedge clk) begin
  if (load) begin
    // Update grid with the loaded data
    for (int i = 0; i < 256; i = i + 16) begin
      for (int j = 0; j < 16; j = j + 1) begin
        grid[i/16][j] = data[i+j];
      end
    end
  end 
  else begin
    // Calculate the next state of the game
    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        integer alive_neighbors = count_neighbors(i, j);
        
        if (grid[i][j] == 1) begin
          if (alive_neighbors < 2 || alive_neighbors >= 4)
            q[i*16+j] <= 0;
          else
            q[i*16+j] <= 1;
        end
        else begin
          if (alive_neighbors == 3)
            q[i*16+j] <= 1;
          else
            q[i*16+j] <= 0;
        end
      end
    end
  end
end

endmodule