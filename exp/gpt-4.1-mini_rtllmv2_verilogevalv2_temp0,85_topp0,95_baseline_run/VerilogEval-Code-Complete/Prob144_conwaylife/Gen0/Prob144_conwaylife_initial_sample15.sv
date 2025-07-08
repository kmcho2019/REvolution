module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  // grid dimensions
  localparam WIDTH = 16;
  localparam HEIGHT = 16;

  // function to get cell value from q by row and column with wrap-around
  function automatic bit get_cell(input [255:0] grid, input integer row, input integer col);
    integer r, c;
    begin
      r = (row < 0) ? (HEIGHT + row) : (row % HEIGHT);
      c = (col < 0) ? (WIDTH + col) : (col % WIDTH);
      get_cell = grid[r*WIDTH + c];
    end
  endfunction

  integer r, c;
  integer dr, dc;

  reg [255:0] next_q;

  always @(*) begin
    // For each cell compute neighbor count and apply rules
    for (r = 0; r < HEIGHT; r = r + 1) begin
      for (c = 0; c < WIDTH; c = c + 1) begin
        integer count;
        bit current_cell;
        count = 0;
        current_cell = get_cell(q, r, c);
        // sum neighbors
        for (dr = -1; dr <= 1; dr = dr + 1) begin
          for (dc = -1; dc <= 1; dc = dc + 1) begin
            if (!(dr == 0 && dc == 0)) begin
              count = count + get_cell(q, r + dr, c + dc);
            end
          end
        end
        // apply rules
        if (count <= 1)
          next_q[r*WIDTH + c] = 1'b0;
        else if (count == 2)
          next_q[r*WIDTH + c] = current_cell;
        else if (count == 3)
          next_q[r*WIDTH + c] = 1'b1;
        else // count >= 4
          next_q[r*WIDTH + c] = 1'b0;
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