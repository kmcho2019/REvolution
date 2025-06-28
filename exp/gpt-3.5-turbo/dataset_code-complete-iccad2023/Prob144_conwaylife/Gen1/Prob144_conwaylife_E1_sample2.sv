module Cell (
  input clk,
  input [255:0] q,
  output reg [255:0] next_q
);

  // Define a lookup table for neighbor coordinates
  reg [7:0] neighbor_coords [8:0];
  initial begin
    neighbor_coords[0] = 8'b00000001;  // Right Neighbor
    neighbor_coords[1] = 8'b10000000;  // Left Neighbor
    neighbor_coords[2] = 8'b00010000;  // Top Neighbor
    neighbor_coords[3] = 8'b01000000;  // Bottom Neighbor
    neighbor_coords[4] = 8'b00010001;  // Top Right Neighbor
    neighbor_coords[5] = 8'b10010000;  // Top Left Neighbor
    neighbor_coords[6] = 8'b01010001;  // Bottom Right Neighbor
    neighbor_coords[7] = 8'b11010000;  // Bottom Left Neighbor
    neighbor_coords[8] = 8'b00000000;  // Self for optimization
  end

  always @(posedge clk) begin
    // Loop through each cell in the grid
    genvar i, j;
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        // Calculate number of neighbors for cell (i,j)
        int neighbors = 0;
        genvar k;
        for (k = 0; k < 8; k = k + 1) begin
          int x = i + (neighbor_coords[k] & 4'hF);  // Neighbor x coordinate
          int y = j + (neighbor_coords[k] >> 4);    // Neighbor y coordinate
          
          // Wrap around for toroidal grid
          if (x < 0) x = 15;
          if (x > 15) x = 0;
          if (y < 0) y = 15;
          if (y > 15) y = 0;
          
          if (q[x*16 + y]) neighbors = neighbors + 1;
        end

        // Update cell state based on the number of neighbors
        if (neighbors == 3) begin
          next_q[i*16 + j] <= 1;  // Cell becomes alive
        end
        else if (neighbors == 2) begin
          next_q[i*16 + j] <= q[i*16 + j];  // Cell state does not change
        end
        else begin
          next_q[i*16 + j] <= 0;  // Cell becomes dead
        end
      end
    end
  end
endmodule

module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  // Implementing the cell module for updating the grid
  Cell cell_inst (
    .clk(clk),
    .q(q),
    .next_q(q)
  );

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end
  end

endmodule