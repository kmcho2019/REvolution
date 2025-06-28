module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] next_q;

// Function to count alive neighbors for a cell at position (i, j)
function integer count_neighbors;
  input i, j;
  integer count;
  begin
    count = 0;
    for (int dx = -1; dx <= 1; dx = dx + 1) begin
      for (int dy = -1; dy <= 1; dy = dy + 1) begin
        if (dx == 0 && dy == 0) continue; // Exclude the cell itself
        count = count + q[((i+dx+16)%16)*16 + (j+dy+16)%16];
      end
    end
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
        if (neighbors <= 1 || neighbors >= 4) begin
          next_q[i*16 + j] = 0; // Cell becomes 0
        end else if (neighbors == 3) begin
          next_q[i*16 + j] = 1; // Cell becomes 1
        end else begin
          next_q[i*16 + j] = q[i*16 + j]; // Cell state does not change
        end
      end
    end
    q <= next_q;
  end
end

endmodule