module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // Parameters
  localparam SIZE = 16;
  
  // Internal 2D grid representation for current and next states
  reg grid[0:SIZE-1][0:SIZE-1];
  reg next_grid[0:SIZE-1][0:SIZE-1];
  
  integer r, c;
  
  // Convert 1D q vector to 2D grid for processing
  always @(*) begin
    for (r = 0; r < SIZE; r = r + 1) begin
      for (c = 0; c < SIZE; c = c + 1) begin
        grid[r][c] = q[r*SIZE + c];
      end
    end
  end

  // Compute next state each clock cycle
  always @(posedge clk) begin
    if (load) begin
      // Load input data into q
      q <= data;
    end else begin
      // Compute neighbor counts and next_grid state
      for (r = 0; r < SIZE; r = r + 1) begin
        for (c = 0; c < SIZE; c = c + 1) begin
          // Count neighbors with wrap-around
          integer nr, nc;
          integer neighbors;
          neighbors = 0;
          for (nr = r - 1; nr <= r + 1; nr = nr + 1) begin
            for (nc = c - 1; nc <= c + 1; nc = nc + 1) begin
              if (!(nr == r && nc == c)) begin
                // Wrap around
                integer rr = (nr + SIZE) % SIZE;
                integer cc = (nc + SIZE) % SIZE;
                neighbors = neighbors + grid[rr][cc];
              end
            end
          end
          // Apply rules
          if (neighbors <= 1)
            next_grid[r][c] = 0;
          else if (neighbors == 2)
            next_grid[r][c] = grid[r][c];
          else if (neighbors == 3)
            next_grid[r][c] = 1;
          else
            next_grid[r][c] = 0;
        end
      end
      
      // Flatten next_grid back to q
      for (r = 0; r < SIZE; r = r + 1) begin
        for (c = 0; c < SIZE; c = c + 1) begin
          q[r*SIZE + c] <= next_grid[r][c];
        end
      end
    end
  end

endmodule