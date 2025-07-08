module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  
  // Parameters for grid size
  localparam N = 16;
  
  integer r, c, dr, dc;
  reg [3:0] neighbors; // up to 8 neighbors, 4 bits enough
  reg cell_state;
  
  reg [255:0] next_q;
  
  // Function to wrap row or col index for toroidal grid
  function [3:0] wrap;
    input integer idx;
    begin
      if (idx < 0)
        wrap = idx + N;
      else if (idx >= N)
        wrap = idx - N;
      else
        wrap = idx[3:0];
    end
  endfunction
  
  always @* begin
    // Compute next_q combinationally
    for (r = 0; r < N; r = r + 1) begin
      for (c = 0; c < N; c = c + 1) begin
        neighbors = 0;
        // sum neighbors
        for (dr = -1; dr <= 1; dr = dr + 1) begin
          for (dc = -1; dc <= 1; dc = dc + 1) begin
            if (!(dr == 0 && dc == 0)) begin
              // wrapped neighbor row and col
              integer rr = wrap(r + dr);
              integer cc = wrap(c + dc);
              neighbors = neighbors + q[rr*16 + cc];
            end
          end
        end
        
        cell_state = q[r*16 + c];
        // apply rules:
        // neighbors: 0 or 1 -> 0
        // neighbors: 2 -> cell unchanged
        // neighbors: 3 -> 1
        // neighbors: 4+ -> 0
        if (neighbors <= 1)
          next_q[r*16 + c] = 1'b0;
        else if (neighbors == 2)
          next_q[r*16 + c] = cell_state;
        else if (neighbors == 3)
          next_q[r*16 + c] = 1'b1;
        else // neighbors >= 4
          next_q[r*16 + c] = 1'b0;
      end
    end
  end
  
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= next_q;
    end
  end

endmodule