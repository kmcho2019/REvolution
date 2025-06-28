module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] next_q; // Next state of the grid

// Calculate the number of neighbors for each cell
always @*
begin
  integer i, j, neighbors;

  for (i = 0; i < 16; i = i + 1) begin
    for (j = 0; j < 16; j = j + 1) begin
      neighbors = 
        q[((i+15)%16)*16 + ((j+1)%16)] + // Right
        q[((i+15)%16)*16 + ((j+15)%16)] + // Top-right
        q[((i+15)%16)*16 + j] + // Top
        q[(i*16) + ((j+1)%16)] + // Bottom
        q[(i*16) + ((j+15)%16)] + // Bottom-right
        q[(i*16) + j] + // Left
        q[((i+1)%16)*16 + ((j+1)%16)] + // Bottom-left
        q[((i+1)%16)*16 + ((j+15)%16)]; // Top-left

      // Update cell state based on the number of neighbors and rules
      if (neighbors == 3 || (q[i*16+j] && neighbors == 2))
        next_q[i*16+j] = 1; // Cell becomes alive or stays alive
      else
        next_q[i*16+j] = 0; // Cell becomes dead
    end
  end
end

// Load data or update the grid at the rising edge of the clock
always @(posedge clk)
begin
  if (load)
    q <= data;
  else
    q <= next_q;
end

endmodule