module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] next_q;

// Function to count alive neighbors for a cell at position (i, j) with toroidal wrap-around
function integer count_neighbors;
  input i, j;
  integer count;
  begin
    count = q[((i+15)%16)*16 + (j+15)%16] + q[((i+15)%16)*16 + j] + q[((i+15)%16)*16 + (j+1)%16] +
            q[(i*16 + (j+15)%16)] + q[(i*16 + (j+1)%16)] +
            q[((i+1)%16)*16 + (j+15)%16] + q[((i+1)%16)*16 + j] + q[((i+1)%16)*16 + (j+1)%16];
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
        
        if (neighbors <= 1) begin
          next_q[i*16 + j] = 0; // Cell becomes 0
        end else if (neighbors == 2) begin
          next_q[i*16 + j] = q[i*16 + j]; // Cell state does not change
        end else if (neighbors == 3) begin
          next_q[i*16 + j] = 1; // Cell becomes 1
        end else begin
          next_q[i*16 + j] = 0; // Cell becomes 0
        end
      end
    end
    q <= next_q;
  end
end

endmodule