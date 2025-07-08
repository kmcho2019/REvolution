module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  // Function to get the value of a cell at (x,y) with wrap-around
  function get_cell;
    input [3:0] x;  // 0-15
    input [3:0] y;  // 0-15
    input [255:0] grid;
    begin
      get_cell = grid[(y*16) + x];
    end
  endfunction

  // Function to count live neighbors for cell at (x,y)
  function [3:0] count_neighbors;
    input [3:0] x;
    input [3:0] y;
    input [255:0] grid;
    reg [3:0] xm1, xp1, ym1, yp1;
    begin
      // Calculate wrapped coordinates
      xm1 = (x == 0) ? 15 : x - 1;
      xp1 = (x == 15) ? 0 : x + 1;
      ym1 = (y == 0) ? 15 : y - 1;
      yp1 = (y == 15) ? 0 : y + 1;
      
      // Count all 8 neighbors
      count_neighbors = 
        get_cell(xm1, ym1, grid) + get_cell(x, ym1, grid) + get_cell(xp1, ym1, grid) +
        get_cell(xm1, y, grid) + get_cell(xp1, y, grid) +
        get_cell(xm1, yp1, grid) + get_cell(x, yp1, grid) + get_cell(xp1, yp1, grid);
    end
  endfunction

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Update each cell in parallel
      for (integer y = 0; y < 16; y = y + 1) begin
        for (integer x = 0; x < 16; x = x + 1) begin
          reg [3:0] neighbors;
          neighbors = count_neighbors(x[3:0], y[3:0], q);
          
          // Apply game rules
          case (neighbors)
            0, 1: q[y*16 + x] <= 0;
            2: q[y*16 + x] <= q[y*16 + x];  // keep state
            3: q[y*16 + x] <= 1;
            default: q[y*16 + x] <= 0;  // 4+
          endcase
        end
      end
    end
  end

endmodule