module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // Parameters for grid size
  localparam WIDTH = 16;
  localparam HEIGHT = 16;

  // Internal signal to hold next state
  reg [255:0] next_q;

  // Function to compute wrapped index (0 to 15)
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

  // Compute the number of neighbors for each cell considering toroidal wrap-around
  integer r, c, dr, dc;
  integer nr, nc;
  integer neighbor_count;

  always @(*) begin
    // Default next_q to zero
    next_q = 0;

    for (r = 0; r < HEIGHT; r = r + 1) begin
      for (c = 0; c < WIDTH; c = c + 1) begin
        // Count neighbors
        neighbor_count = 0;
        for (dr = -1; dr <= 1; dr = dr + 1) begin
          for (dc = -1; dc <= 1; dc = dc + 1) begin
            if (!(dr == 0 && dc == 0)) begin
              nr = (r + dr);
              nc = (c + dc);
              // Wrap around toroidally
              if (nr < 0)
                nr = nr + HEIGHT;
              else if (nr >= HEIGHT)
                nr = nr - HEIGHT;
              if (nc < 0)
                nc = nc + WIDTH;
              else if (nc >= WIDTH)
                nc = nc - WIDTH;
              // Index in q: row * 16 + col
              neighbor_count = neighbor_count + q[nr*WIDTH + nc];
            end
          end
        end

        // Current cell state
        if (load)
          next_q[r*WIDTH + c] = data[r*WIDTH + c];
        else begin
          case (neighbor_count)
            0,1: next_q[r*WIDTH + c] = 1'b0;
            2:   next_q[r*WIDTH + c] = q[r*WIDTH + c]; // no change
            3:   next_q[r*WIDTH + c] = 1'b1;
            default: next_q[r*WIDTH + c] = 1'b0; // 4 or more neighbors
          endcase
        end
      end
    end
  end

  always @(posedge clk) begin
    q <= next_q;
  end
endmodule