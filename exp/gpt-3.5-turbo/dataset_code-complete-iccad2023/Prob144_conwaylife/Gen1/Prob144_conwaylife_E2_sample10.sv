module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  reg [255:0] next_q;
  
  // Implementing the logic for updating the cell state
  always @(*) begin
    // Loop through each cell in the grid
    integer i, j;
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        // Calculate number of neighbors for cell (i,j)
        int neighbors = 0;
        if (q[i*16 + ((j+1) & 15)]) neighbors = neighbors + 1;          // Right Neighbor
        if (q[i*16 + ((j-1) & 15)]) neighbors = neighbors + 1;          // Left Neighbor
        if (q[((i+1) & 15) * 16 + j]) neighbors = neighbors + 1;        // Top Neighbor
        if (q[((i-1) & 15) * 16 + j]) neighbors = neighbors + 1;        // Bottom Neighbor
        if (q[((i+1) & 15) * 16 + ((j+1) & 15)]) neighbors = neighbors + 1;  // Top Right Neighbor
        if (q[((i+1) & 15) * 16 + ((j-1) & 15)]) neighbors = neighbors + 1;  // Top Left Neighbor
        if (q[((i-1) & 15) * 16 + ((j+1) & 15)]) neighbors = neighbors + 1;  // Bottom Right Neighbor
        if (q[((i-1) & 15) * 16 + ((j-1) & 15)]) neighbors = neighbors + 1;  // Bottom Left Neighbor

        // Update cell state based on the number of neighbors
        if (neighbors == 3) begin
          next_q[i*16 + j] = 1;  // Cell becomes alive
        end
        else if (neighbors == 2) begin
          next_q[i*16 + j] = q[i*16 + j];  // Cell state does not change
        end
        else begin
          next_q[i*16 + j] = 0;  // Cell becomes dead
        end
      end
    end
  end

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end
    else begin
      q <= next_q; // Update the grid with the new state
    end
  end

endmodule