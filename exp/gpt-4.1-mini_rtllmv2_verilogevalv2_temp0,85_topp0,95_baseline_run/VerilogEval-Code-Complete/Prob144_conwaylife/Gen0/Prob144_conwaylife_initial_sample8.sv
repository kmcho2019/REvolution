module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // 16 rows, each 16 bits wide, representing the grid
  reg [15:0] grid [0:15];
  reg [15:0] next_grid [0:15];

  integer r, c;

  // Helper function to get cell value with wrapping
  function automatic bit get_cell(input integer row, input integer col);
    begin
      get_cell = grid[row & 4'hF][col & 4'hF];
    end
  endfunction

  // Count neighbors of cell (r,c) with wrap-around
  function automatic [3:0] count_neighbors(input integer r, input integer c);
    integer dr, dc;
    integer rr, cc;
    reg [3:0] count;
    begin
      count = 0;
      for (dr = -1; dr <= 1; dr = dr + 1) begin
        for (dc = -1; dc <= 1; dc = dc + 1) begin
          if (!(dr == 0 && dc == 0)) begin
            rr = (r + dr) & 4'hF;
            cc = (c + dc) & 4'hF;
            count = count + grid[rr][cc];
          end
        end
      end
      count_neighbors = count;
    end
  endfunction

  // Unpack q into grid for neighbor calculation
  always @(*) begin
    for (r = 0; r < 16; r = r + 1)
      grid[r] = q[r*16 +: 16];
  end

  // Compute next_grid combinationally
  always @(*) begin
    for (r = 0; r < 16; r = r + 1) begin
      for (c = 0; c < 16; c = c + 1) begin
        reg [3:0] neighbors;
        reg cell;
        neighbors = count_neighbors(r, c);
        cell = grid[r][c];
        // Apply rules
        if (neighbors <= 1)
          next_grid[r][c] = 0;
        else if (neighbors == 2)
          next_grid[r][c] = cell;
        else if (neighbors == 3)
          next_grid[r][c] = 1;
        else // neighbors >= 4
          next_grid[r][c] = 0;
      end
    end
  end

  // Pack next_grid back into q on clock edge
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      for (r = 0; r < 16; r = r + 1)
        q[r*16 +: 16] <= next_grid[r];
    end
  end

endmodule