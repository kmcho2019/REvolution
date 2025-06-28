module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  always @(*) begin
    // Create a temporary vector to store the state of cells and their neighbors
    reg [255:0] ext_q;
    
    // Shift the grid up, down, left, and right
    ext_q[0:239] = {q[16:255], q[0:15]};  // Shift grid up
    ext_q[240:255] = q[0:15];  // Add top row at the bottom for toroidal effect
    ext_q[256:255] = q;  // Current set of cells
    ext_q[256:511] = ext_q[0:255];  // Duplicate for the bottom
    ext_q[512:767] = {q[240:255], q[0:239]};  // Shift grid down
    
    // Loop through each cell in the grid
    genvar i, j;
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        // Calculate number of neighbors for cell (i,j)
        int neighbors = 0;
        neighbors = ext_q[256 + ((i-1) * 16) + j-1] + ext_q[256 + ((i-1) * 16) + j] + ext_q[256 + ((i-1) * 16) + j+1]
                  + ext_q[256 + (i * 16) + j-1] + ext_q[256 + (i * 16) + j+1]
                  + ext_q[256 + ((i+1) * 16) + j-1] + ext_q[256 + ((i+1) * 16) + j] + ext_q[256 + ((i+1) * 16) + j+1];

        // Update cell state based on the number of neighbors
        if (neighbors == 3) begin
          q[i*16 + j] <= 1;  // Cell becomes alive
        end
        else if (neighbors == 2) begin
          q[i*16 + j] <= q[i*16 + j];  // Cell state does not change
        end
        else begin
          q[i*16 + j] <= 0;  // Cell becomes dead
        end
      end
    end
  end

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end
  end

endmodule