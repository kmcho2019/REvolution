module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  // Internal 2D representation of the grid for easy indexing
  reg grid [0:15][0:15];
  reg next_grid [0:15][0:15];

  integer r, c;

  // Convert flat q vector to 2D grid on load
  always @(posedge clk) begin
    if (load) begin
      for (r = 0; r < 16; r = r + 1) begin
        for (c = 0; c < 16; c = c + 1) begin
          grid[r][c] <= data[r*16 + c];
        end
      end
    end else begin
      // Compute next state for each cell
      for (r = 0; r < 16; r = r + 1) begin
        for (c = 0; c < 16; c = c + 1) begin
          integer nr, nc;
          integer count;
          count = 0;

          // Check all 8 neighbors with toroidal wrap
          for (nr = -1; nr <= 1; nr = nr + 1) begin
            for (nc = -1; nc <= 1; nc = nc + 1) begin
              if (!(nr == 0 && nc == 0)) begin
                // wrap row and col indices modulo 16
                integer rr = (r + nr + 16) % 16;
                integer cc = (c + nc + 16) % 16;
                count = count + grid[rr][cc];
              end
            end
          end

          // Apply rules:
          // 0-1 neighbor: dead
          // 2 neighbors: no change
          // 3 neighbors: alive
          // 4+ neighbors: dead
          if (count <= 1)
            next_grid[r][c] = 1'b0;
          else if (count == 2)
            next_grid[r][c] = grid[r][c];
          else if (count == 3)
            next_grid[r][c] = 1'b1;
          else // count >= 4
            next_grid[r][c] = 1'b0;
        end
      end

      // Update grid with next state
      for (r = 0; r < 16; r = r + 1) begin
        for (c = 0; c < 16; c = c + 1) begin
          grid[r][c] <= next_grid[r][c];
        end
      end
    end
  end

  // Convert 2D grid back to flat output q continuously
  always @(*) begin
    for (r = 0; r < 16; r = r + 1) begin
      for (c = 0; c < 16; c = c + 1) begin
        q[r*16 + c] = grid[r][c];
      end
    end
  end

endmodule