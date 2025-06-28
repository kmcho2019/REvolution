module GameOfLife (
  input [255:0] q,
  output reg [255:0] next_q
);

reg [255:0] neighbour_count;

always @*
begin
  // Calculate the number of live neighbors for each cell
  for (int i = 0; i < 16; i = i + 1) begin
    for (int j = 0; j < 16; j = j + 1) begin
      int cnt = 0;
      cnt = cnt + q[((i+15)%16)*16 + ((j+15)%16)]; // Top-left
      cnt = cnt + q[((i+15)%16)*16 + j];           // Top
      cnt = cnt + q[((i+15)%16)*16 + ((j+1)%16)];  // Top-right
      cnt = cnt + q[i*16 + ((j+15)%16)];           // Left
      cnt = cnt + q[i*16 + ((j+1)%16)];            // Right
      cnt = cnt + q[((i+1)%16)*16 + ((j+15)%16)];  // Bottom-left
      cnt = cnt + q[((i+1)%16)*16 + j];            // Bottom
      cnt = cnt + q[((i+1)%16)*16 + ((j+1)%16)];   // Bottom-right

      neighbour_count[i*16 + j] = cnt;
    end
  end
  
  // Update the state of each cell based on the number of live neighbors
  for (int i = 0; i < 256; i = i + 1) begin
    if (neighbour_count[i] == 1'b0 || neighbour_count[i] >= 4)
      next_q[i] = 1'b0; // Cell becomes 0
    else if (neighbour_count[i] == 2)
      next_q[i] = q[i]; // Cell state does not change
    else if (neighbour_count[i] == 3)
      next_q[i] = 1'b1; // Cell becomes 1
  end
end

endmodule