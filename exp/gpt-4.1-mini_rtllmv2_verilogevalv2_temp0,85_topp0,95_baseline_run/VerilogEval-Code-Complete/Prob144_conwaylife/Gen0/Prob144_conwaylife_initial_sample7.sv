module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // parameters for grid size
  localparam WIDTH = 16;
  localparam HEIGHT = 16;

  // 2D indexing helpers:
  // q[row*16 + col] is the cell at (row, col)
  // We'll store next state in a reg array for convenience
  reg [WIDTH-1:0] grid [0:HEIGHT-1];
  reg [WIDTH-1:0] next_grid [0:HEIGHT-1];

  integer r, c;

  // Convert 1D q vector into 2D grid on posedge clk or load
  always @(posedge clk) begin
    if (load) begin
      // load data into q and grid
      q <= data;
      // unpack data into grid rows
      for (r = 0; r < HEIGHT; r = r + 1) begin
        grid[r] <= data[r*WIDTH +: WIDTH];
      end
    end else begin
      // update q and grid to next state
      q <= 0;
      for (r = 0; r < HEIGHT; r = r + 1) begin
        grid[r] <= next_grid[r];
        q[r*WIDTH +: WIDTH] <= next_grid[r];
      end
    end
  end

  // combinational logic to compute next_grid based on grid
  always @(*) begin
    for (r = 0; r < HEIGHT; r = r + 1) begin
      for (c = 0; c < WIDTH; c = c + 1) begin
        // compute number of live neighbors with wrap-around
        integer rr, cc;
        integer count;
        count = 0;
        for (rr = -1; rr <= 1; rr = rr + 1) begin
          for (cc = -1; cc <= 1; cc = cc + 1) begin
            if (!(rr == 0 && cc == 0)) begin
              // wrap row and col
              integer nr, nc;
              nr = (r + rr + HEIGHT) % HEIGHT;
              nc = (c + cc + WIDTH) % WIDTH;
              count = count + grid[nr][nc];
            end
          end
        end

        // apply the rules
        if (count <= 1) next_grid[r][c] = 0;
        else if (count == 2) next_grid[r][c] = grid[r][c];
        else if (count == 3) next_grid[r][c] = 1;
        else /* count >= 4 */ next_grid[r][c] = 0;
      end
    end
  end

endmodule