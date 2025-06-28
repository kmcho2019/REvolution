module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] tmp_q; // Temporary variable to hold the updated values

// Generate 16x16 toroid grid
always @(*)
begin
  integer i, j;
  for(i = 0; i < 16; i = i + 1) begin
    for(j = 0; j < 16; j = j + 1) begin
      integer neighbors = 
        q[((i+15)%16)*16 + ((j+1)%16)] + // Right
        q[((i+15)%16)*16 + ((j+15)%16)] + // Top-right
        q[((i+15)%16)*16 + j] + // Top
        q[(i*16) + ((j+1)%16)] + // Bottom
        q[(i*16) + ((j+15)%16)] + // Bottom-right
        q[(i*16) + j] + // Left
        q[((i+1)%16)*16 + ((j+1)%16)] + // Bottom-left
        q[((i+1)%16)*16 + ((j+15)%16)]; // Top-left

      if(q[i*16+j] == 1) begin
        if(neighbors <= 1 || neighbors >= 4)
          tmp_q[i*16+j] = 0; // Rule 1 and 4
        else
          tmp_q[i*16+j] = 1; // Rule 2
      end
      else begin
        if(neighbors == 3)
          tmp_q[i*16+j] = 1; // Rule 3
        else
          tmp_q[i*16+j] = 0;
      end
    end
  end
end

// Load values into q on the rising edge of the clock
always @(posedge clk)
begin
  if(load)
    q <= data;
  else
    q <= tmp_q;
end

endmodule