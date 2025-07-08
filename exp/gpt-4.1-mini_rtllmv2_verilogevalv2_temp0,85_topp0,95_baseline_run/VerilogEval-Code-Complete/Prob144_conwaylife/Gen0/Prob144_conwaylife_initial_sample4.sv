module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  // Function to get bit at (row, col) with wrap-around indexing
  function automatic bit get_cell(input [255:0] grid, input integer row, input integer col);
    integer r, c;
    begin
      r = (row + 16) % 16;
      c = (col + 16) % 16;
      get_cell = grid[r*16 + c];
    end
  endfunction

  // Function to count live neighbors of cell at (row, col)
  function automatic [3:0] count_neighbors(input [255:0] grid, input integer row, input integer col);
    integer dr, dc;
    integer nr, nc;
    integer count;
    begin
      count = 0;
      for (dr = -1; dr <= 1; dr = dr + 1) begin
        for (dc = -1; dc <= 1; dc = dc + 1) begin
          if (!(dr == 0 && dc == 0)) begin
            nr = (row + dr + 16) % 16;
            nc = (col + dc + 16) % 16;
            count = count + get_cell(grid, nr, nc);
          end
        end
      end
      count_neighbors = count[3:0];
    end
  endfunction

  integer i, j;
  reg [255:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Compute next_q by applying the rules for each cell
      for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
          reg [3:0] neighbors;
          reg current_cell;
          neighbors = count_neighbors(q, i, j);
          current_cell = q[i*16 + j];

          // Apply rules:
          // 0-1 neighbors: cell becomes 0
          // 2 neighbors: cell state unchanged
          // 3 neighbors: cell becomes 1
          // 4+ neighbors: cell becomes 0
          if (neighbors <= 1)
            next_q[i*16 + j] = 1'b0;
          else if (neighbors == 2)
            next_q[i*16 + j] = current_cell;
          else if (neighbors == 3)
            next_q[i*16 + j] = 1'b1;
          else
            next_q[i*16 + j] = 1'b0;
        end
      end
      q <= next_q;
    end
  end

endmodule