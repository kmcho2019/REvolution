module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

// Function to count alive neighbors for a cell at position (i, j) with toroidal wrap-around
function integer count_neighbors;
  input i, j;
  begin
    integer sum = 0;
    // Calculate alive neighbor count using toroidal wrap-around
    for (int dx = -1; dx <= 1; dx = dx + 1) begin
      for (int dy = -1; dy <= 1; dy = dy + 1) begin
        if (dx != 0 || dy != 0) begin
          sum = sum + q[((i+dx+16)%16)*16 + (j+dy+16)%16];
        end
      end
    end
    return sum;
  end
endfunction

// Update game state every clock cycle
always @(posedge clk) begin
  if (load) begin
    q <= data;
  end else begin
    reg [255:0] next_q;
    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        integer neighbors = count_neighbors(i, j);
        
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