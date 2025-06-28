module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] next_q;

// Compute neighbors for each cell considering toroidal wrap-around
function integer count_neighbors;
  input x, y;
  integer count;
  begin
    count = q[x*16 + y] + q[x*16 + (y+1) & 15] + q[x*16 + (y-1) & 15] + 
            q[((x+1) & 15)*16 + y] + q[((x-1) & 15)*16 + y] + 
            q[((x+1) & 15)*16 + (y+1) & 15] + q[((x+1) & 15)*16 + (y-1) & 15] + 
            q[((x-1) & 15)*16 + (y+1) & 15] + q[((x-1) & 15)*16 + (y-1) & 15];
  end
endfunction

// Update game state every clock cycle
always @(posedge clk) begin
  if (load) begin
    q <= data;
  end else begin
    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        integer neighbors = count_neighbors(i, j);

        // Update cell state based on the number of neighbors
        case(neighbors)
          0, 1: next_q[i*16 + j] = 0; // Cell becomes 0
          2: next_q[i*16 + j] = q[i*16 + j]; // Cell state does not change
          3: next_q[i*16 + j] = 1; // Cell becomes 1
          default: next_q[i*16 + j] = 0; // Cell becomes 0
        endcase
      end
    end
    q <= next_q;
  end
end

endmodule