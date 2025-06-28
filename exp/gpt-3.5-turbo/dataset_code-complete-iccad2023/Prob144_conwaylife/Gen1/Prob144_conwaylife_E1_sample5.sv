module GameOfLife (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  always @ (posedge clk) begin
    // Create a 16x16 temporary grid to store the updated cell states
    reg [15:0][15:0] temp_grid;

    // Loop through each cell in the grid
    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        int neighbours = 0;

        // Calculate the number of live neighbors for each cell
        for (int dx = -1; dx <= 1; dx = dx + 1) begin
          for (int dy = -1; dy <= 1; dy = dy + 1) begin
            if (dx == 0 && dy == 0) continue; // Skip the current cell
            neighbours = neighbours + q[((i + dx + 16) % 16) * 16 + ((j + dy + 16) % 16)];
          end
        end

        // Update the cell state based on the number of live neighbors
        if (neighbours <= 1 || neighbours >= 4)
          temp_grid[i][j] = 1'b0; // Cell becomes 0
        else if (neighbours == 3)
          temp_grid[i][j] = 1'b1; // Cell becomes 1
        else
          temp_grid[i][j] = q[i*16 + j]; // Cell state does not change
      end
    end

    // Update the main grid with the new cell states
    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        q[i*16 + j] = temp_grid[i][j];
      end
    end
  end

endmodule