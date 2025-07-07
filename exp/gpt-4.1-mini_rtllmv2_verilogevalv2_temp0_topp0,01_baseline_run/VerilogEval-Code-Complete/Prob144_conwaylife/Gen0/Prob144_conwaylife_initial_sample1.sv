module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // Parameters for grid size
  localparam N = 16;

  // Internal register to hold next state
  reg [255:0] next_q;

  integer r, c;
  integer rr, cc;
  integer neighbor_count;
  reg cell_state;

  // Function to get the bit at (row, col) from q
  function bit get_cell(input [255:0] grid, input integer row, input integer col);
    begin
      // row * 16 + col
      get_cell = grid[row*16 + col];
    end
  endfunction

  // Function to set the bit at (row, col) in a reg
  function [255:0] set_cell(input [255:0] grid, input integer row, input integer col, input bit val);
    reg [255:0] temp;
    integer idx;
    begin
      temp = grid;
      idx = row*16 + col;
      temp[idx] = val;
      set_cell = temp;
    end
  endfunction

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      next_q = 256'b0;
      for (r = 0; r < N; r = r + 1) begin
        for (c = 0; c < N; c = c + 1) begin
          neighbor_count = 0;
          // Sum neighbors with wrap-around
          // neighbors are at (r-1,c-1), (r-1,c), (r-1,c+1),
          // (r,c-1),           (r,c+1),
          // (r+1,c-1), (r+1,c), (r+1,c+1)
          for (rr = r-1; rr <= r+1; rr = rr + 1) begin
            for (cc = c-1; cc <= c+1; cc = cc + 1) begin
              if (!(rr == r && cc == c)) begin
                // Wrap around indices
                integer wrapped_r = (rr + N) % N;
                integer wrapped_c = (cc + N) % N;
                neighbor_count = neighbor_count + get_cell(q, wrapped_r, wrapped_c);
              end
            end
          end
          cell_state = get_cell(q, r, c);
          // Apply rules
          if (neighbor_count <= 1)
            cell_state = 0;
          else if (neighbor_count == 2)
            cell_state = cell_state;
          else if (neighbor_count == 3)
            cell_state = 1;
          else // neighbor_count >= 4
            cell_state = 0;

          next_q = set_cell(next_q, r, c, cell_state);
        end
      end
      q <= next_q;
    end
  end

endmodule