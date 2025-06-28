module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  always @ (posedge clk) begin
    if (load) begin
      q <= data;   // Load initial state
    end
    else begin
      // Calculate number of neighbors and update cell state for each cell
      reg [7:0] neighbors;
      reg [255:0] next_q;

      // Loop through each cell in the grid
      for (int i = 0; i < 16; i = i + 1) begin
        for (int j = 0; j < 16; j = j + 1) begin
          neighbors = q[i*16 + ((j+1) & 15)] + q[i*16 + ((j-1) & 15)] +
                      q[((i+1) & 15) * 16 + j] + q[((i-1) & 15) * 16 + j] +
                      q[((i+1) & 15) * 16 + ((j+1) & 15)] + q[((i+1) & 15) * 16 + ((j-1) & 15)] +
                      q[((i-1) & 15) * 16 + ((j+1) & 15)] + q[((i-1) & 15) * 16 + ((j-1) & 15)];

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

      q <= next_q;  // Update the grid state
    end
  end

endmodule