module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // Parameters for size
  localparam WIDTH = 16;
  localparam HEIGHT = 16;

  // Function to compute modulo with wrap-around for indexing
  function [3:0] mod_index;
    input integer idx;
    begin
      if (idx < 0)
        mod_index = idx + WIDTH;
      else if (idx >= WIDTH)
        mod_index = idx - WIDTH;
      else
        mod_index = idx[3:0];
    end
  endfunction

  // Next state vector
  reg [255:0] next_q;

  integer row, col, n_row, n_col;
  integer count;

  // Because we cannot use loops directly in always blocks for synthesis,
  // use an always block with nested loops to compute next_q combinationally.
  always @* begin
    for (row = 0; row < HEIGHT; row = row + 1) begin
      for (col = 0; col < WIDTH; col = col + 1) begin
        count = 0;

        // Count neighbors around (row,col)
        // 8 directions: (dr, dc) pairs
        // (-1,-1), (-1,0), (-1,1)
        // (0,-1),         (0,1)
        // (1,-1),  (1,0), (1,1)
        for (n_row = -1; n_row <= 1; n_row = n_row + 1) begin
          for (n_col = -1; n_col <= 1; n_col = n_col + 1) begin
            if (!(n_row == 0 && n_col == 0)) begin
              // Compute wrapped neighbor indices
              integer rr = mod_index(row + n_row);
              integer cc = mod_index(col + n_col);

              // Extract neighbor cell value
              if (q[rr*WIDTH + cc])
                count = count + 1;
            end
          end
        end

        // Current cell value
        wire current = q[row*WIDTH + col];

        // Apply rules
        if (count <= 1)
          next_q[row*WIDTH + col] = 1'b0;            // 0-1 neighbor: dead
        else if (count == 2)
          next_q[row*WIDTH + col] = current;          // 2 neighbors: unchanged
        else if (count == 3)
          next_q[row*WIDTH + col] = 1'b1;             // 3 neighbors: alive
        else // count >= 4
          next_q[row*WIDTH + col] = 1'b0;             // 4+ neighbors: dead
      end
    end
  end

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule