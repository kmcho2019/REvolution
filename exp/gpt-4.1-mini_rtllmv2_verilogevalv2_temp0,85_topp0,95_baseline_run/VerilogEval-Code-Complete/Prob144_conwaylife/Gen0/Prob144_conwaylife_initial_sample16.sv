module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // Internal 2D representation for clarity
  reg [0:15][0:15] grid;       // current state
  reg [0:15][0:15] next_grid;  // next state

  integer r, c;

  // Function to get wrapped index for toroidal grid
  function integer wrap;
    input integer idx;
    begin
      if (idx < 0)
        wrap = idx + 16;
      else if (idx > 15)
        wrap = idx - 16;
      else
        wrap = idx;
    end
  endfunction

  always @(posedge clk) begin
    if (load) begin
      // Load input data into grid
      for (r = 0; r < 16; r = r + 1) begin
        for (c = 0; c < 16; c = c + 1) begin
          // q[ (r*16)+c ] corresponds to bit at position (r*16 + c)
          // Note: q[0] is LSB, q[255] is MSB
          grid[r][c] <= data[r*16 + c];
        end
      end
      // After load, q is assigned from data synchronously below
      q <= data;
    end else begin
      // Compute next state
      for (r = 0; r < 16; r = r + 1) begin
        for (c = 0; c < 16; c = c + 1) begin
          integer nr, nc;
          integer neighbors;
          neighbors = 0;
          // Count neighbors around (r,c)
          // Iterate over delta rows and delta cols -1,0,1 excluding (0,0)
          for (integer dr = -1; dr <= 1; dr = dr + 1) begin
            for (integer dc = -1; dc <= 1; dc = dc + 1) begin
              if (!(dr == 0 && dc == 0)) begin
                nr = wrap(r + dr);
                nc = wrap(c + dc);
                neighbors = neighbors + grid[nr][nc];
              end
            end
          end
          // Apply the given rules:
          // 0-1 neighbor -> 0
          // 2 neighbors -> same state
          // 3 neighbors -> 1
          // 4+ neighbors -> 0
          if (neighbors <= 1)
            next_grid[r][c] = 1'b0;
          else if (neighbors == 2)
            next_grid[r][c] = grid[r][c];
          else if (neighbors == 3)
            next_grid[r][c] = 1'b1;
          else
            next_grid[r][c] = 1'b0;
        end
      end
      // Update grid and q with next state
      for (r = 0; r < 16; r = r + 1) begin
        for (c = 0; c < 16; c = c + 1) begin
          grid[r][c] <= next_grid[r][c];
          q[r*16 + c] <= next_grid[r][c];
        end
      end
    end
  end
endmodule