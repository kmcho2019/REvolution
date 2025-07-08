module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // Parameters
  localparam WIDTH = 16;
  localparam HEIGHT = 16;

  // Function to get wrapped index
  function [3:0] wrap_index;
    input integer idx;
    begin
      if (idx < 0)
        wrap_index = idx + WIDTH;
      else if (idx >= WIDTH)
        wrap_index = idx - WIDTH;
      else
        wrap_index = idx[3:0];
    end
  endfunction

  integer r, c;
  reg [255:0] next_q;

  // Extract cell state function
  function get_cell;
    input [255:0] grid;
    input integer row;
    input integer col;
    begin
      // Each row is 16 bits, starting at row*16
      get_cell = grid[row*16 + col];
    end
  endfunction

  always @(*) begin
    // Compute next_q based on q
    next_q = 256'b0;
    for (r = 0; r < HEIGHT; r = r + 1) begin
      for (c = 0; c < WIDTH; c = c + 1) begin
        integer r_up, r_down, c_left, c_right;
        integer ncount;
        reg current_cell;

        // Compute wrapped neighbor indices
        r_up    = (r == 0) ? HEIGHT-1 : r-1;
        r_down  = (r == HEIGHT-1) ? 0 : r+1;
        c_left  = (c == 0) ? WIDTH-1 : c-1;
        c_right = (c == WIDTH-1) ? 0 : c+1;

        current_cell = get_cell(q, r, c);
        // Sum neighbors
        ncount = 0;
        ncount = ncount + get_cell(q, r_up,   c_left);
        ncount = ncount + get_cell(q, r_up,   c);
        ncount = ncount + get_cell(q, r_up,   c_right);
        ncount = ncount + get_cell(q, r,      c_left);
        ncount = ncount + get_cell(q, r,      c_right);
        ncount = ncount + get_cell(q, r_down, c_left);
        ncount = ncount + get_cell(q, r_down, c);
        ncount = ncount + get_cell(q, r_down, c_right);

        // Apply rules
        if (ncount <= 1)
          next_q[r*16 + c] = 1'b0;
        else if (ncount == 2)
          next_q[r*16 + c] = current_cell;
        else if (ncount == 3)
          next_q[r*16 + c] = 1'b1;
        else
          next_q[r*16 + c] = 1'b0;
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