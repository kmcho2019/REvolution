module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  integer r, c, i;
  reg [3:0] neighbors; // max 8 neighbors, 4 bits is enough
  reg cell, next_cell;
  reg [255:0] next_q;

  // Function to get bit at (row,col)
  function bit get_cell;
    input [255:0] grid;
    input integer row;
    input integer col;
    begin
      // Wrap around row and col
      row = row & 4'hF; // modulo 16
      col = col & 4'hF;
      get_cell = grid[row*16 + col];
    end
  endfunction

  always @(*) begin
    // For each cell compute next state
    for (r = 0; r < 16; r = r + 1) begin
      for (c = 0; c < 16; c = c + 1) begin
        neighbors = 0;
        // Sum neighbors (8 surrounding cells)
        neighbors = neighbors
          + get_cell(q, r-1, c-1)
          + get_cell(q, r-1, c)
          + get_cell(q, r-1, c+1)
          + get_cell(q, r,   c-1)
          + get_cell(q, r,   c+1)
          + get_cell(q, r+1, c-1)
          + get_cell(q, r+1, c)
          + get_cell(q, r+1, c+1);

        cell = get_cell(q, r, c);

        // Apply rules:
        // 0-1 neighbors: cell becomes 0
        // 2 neighbors: cell unchanged
        // 3 neighbors: cell becomes 1
        // 4+ neighbors: cell becomes 0
        if (neighbors <= 1)
          next_cell = 1'b0;
        else if (neighbors == 2)
          next_cell = cell;
        else if (neighbors == 3)
          next_cell = 1'b1;
        else
          next_cell = 1'b0;

        next_q[r*16 + c] = next_cell;
      end
    end
  end

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= next_q;
    end
  end

endmodule