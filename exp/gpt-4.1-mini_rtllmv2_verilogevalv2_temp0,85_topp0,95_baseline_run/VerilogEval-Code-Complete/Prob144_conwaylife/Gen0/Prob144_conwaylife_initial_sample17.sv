module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  // Parameters for grid size
  localparam N = 16;

  // Helper function to get bit at (row,col) with wrapping
  function get_cell;
    input [255:0] grid;
    input [3:0] row;
    input [3:0] col;
    begin
      // Each row is 16 bits, row*16 + col bit index
      get_cell = grid[row*16 + col];
    end
  endfunction

  // Function to count neighbors of cell at (row, col)
  function [3:0] count_neighbors;
    input [255:0] grid;
    input [3:0] row;
    input [3:0] col;

    // Variables for neighbor positions
    reg [3:0] r_up, r_down, c_left, c_right;
    reg [3:0] sum;

    begin
      // Calculate wrapped indices
      r_up    = row - 1;
      r_down  = row + 1;
      c_left  = col - 1;
      c_right = col + 1;

      // Wrap around using modulo 16 (mask with 0xF)
      r_up    = r_up  & 4'hF;
      r_down  = r_down & 4'hF;
      c_left  = c_left & 4'hF;
      c_right = c_right & 4'hF;

      sum = 0;
      // Sum all 8 neighbors
      sum = sum
          + get_cell(grid, r_up,   c_left)
          + get_cell(grid, r_up,   col)
          + get_cell(grid, r_up,   c_right)
          + get_cell(grid, row,    c_left)
          + get_cell(grid, row,    c_right)
          + get_cell(grid, r_down, c_left)
          + get_cell(grid, r_down, col)
          + get_cell(grid, r_down, c_right);

      count_neighbors = sum;
    end
  endfunction

  // Next state computation
  reg [255:0] next_q;
  integer i, j;
  reg [3:0] neighbors;
  reg current_cell;

  always @(*) begin
    // Compute next_q combinationally
    for (i = 0; i < N; i = i + 1) begin
      for (j = 0; j < N; j = j + 1) begin
        current_cell = get_cell(q, i[3:0], j[3:0]);
        neighbors = count_neighbors(q, i[3:0], j[3:0]);
        // Apply rules
        // (1) 0-1 neighbor: cell becomes 0
        // (2) 2 neighbors: cell state unchanged
        // (3) 3 neighbors: cell becomes 1
        // (4) 4+ neighbors: cell becomes 0
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
  end

  // Sequential update
  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule