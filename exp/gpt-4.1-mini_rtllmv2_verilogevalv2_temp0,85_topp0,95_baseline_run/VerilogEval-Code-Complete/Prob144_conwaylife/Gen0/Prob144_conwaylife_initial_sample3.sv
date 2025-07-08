module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  
  // Function to get the bit at (row,col) considering wrapping
  function automatic bit get_cell(input [255:0] grid, input integer row, input integer col);
    integer r_wrap, c_wrap;
    begin
      // Wrap rows and columns modulo 16
      r_wrap = (row + 16) % 16;
      c_wrap = (col + 16) % 16;
      get_cell = grid[r_wrap*16 + c_wrap];
    end
  endfunction
  
  integer r, c;
  reg [255:0] next_q;
  integer n_count;
  
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Compute next state for each cell
      for (r = 0; r < 16; r = r + 1) begin
        for (c = 0; c < 16; c = c + 1) begin
          // Count neighbors (8 neighbors)
          n_count = 0;
          n_count = n_count + get_cell(q, r-1, c-1);
          n_count = n_count + get_cell(q, r-1, c);
          n_count = n_count + get_cell(q, r-1, c+1);
          n_count = n_count + get_cell(q, r,   c-1);
          n_count = n_count + get_cell(q, r,   c+1);
          n_count = n_count + get_cell(q, r+1, c-1);
          n_count = n_count + get_cell(q, r+1, c);
          n_count = n_count + get_cell(q, r+1, c+1);
          
          // Apply rules:
          // 0-1 neighbor: cell becomes 0
          // 2 neighbors: cell unchanged
          // 3 neighbors: cell becomes 1
          // 4+ neighbors: cell becomes 0
          if (n_count <= 1) begin
            next_q[r*16 + c] = 1'b0;
          end else if (n_count == 2) begin
            next_q[r*16 + c] = q[r*16 + c];
          end else if (n_count == 3) begin
            next_q[r*16 + c] = 1'b1;
          end else begin
            next_q[r*16 + c] = 1'b0;
          end
        end
      end
      q <= next_q;
    end
  end

endmodule