module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // Parameters for grid size
  localparam WIDTH = 16;
  localparam HEIGHT = 16;

  // Function to get cell state with wrap-around
  function automatic bit get_cell;
    input [3:0] x;
    input [3:0] y;
    begin
      // Wrap around using modulo arithmetic on 4-bit indices
      // Convert x,y to index in q: index = y*16 + x
      get_cell = q[(y*WIDTH)+x];
    end
  endfunction

  integer x, y, dx, dy;
  integer nx, ny;
  reg [3:0] neighbor_count;
  reg [255:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Compute next state for each cell
      for (y = 0; y < HEIGHT; y = y + 1) begin
        for (x = 0; x < WIDTH; x = x + 1) begin
          neighbor_count = 0;
          // Count neighbors in 8 directions with wrap-around
          for (dy = -1; dy <= 1; dy = dy + 1) begin
            for (dx = -1; dx <= 1; dx = dx + 1) begin
              if (!(dx == 0 && dy == 0)) begin
                // Wrap coordinates using modulo 16 arithmetic
                nx = (x + dx + WIDTH) % WIDTH;
                ny = (y + dy + HEIGHT) % HEIGHT;
                if (q[ny*WIDTH + nx])
                  neighbor_count = neighbor_count + 1;
              end
            end
          end

          // Apply the game rules
          if (neighbor_count <= 1)
            next_q[y*WIDTH + x] = 1'b0;
          else if (neighbor_count == 2)
            next_q[y*WIDTH + x] = q[y*WIDTH + x];
          else if (neighbor_count == 3)
            next_q[y*WIDTH + x] = 1'b1;
          else // neighbor_count >= 4
            next_q[y*WIDTH + x] = 1'b0;
        end
      end
      q <= next_q;
    end
  end
endmodule