module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  always @(*) begin
    reg [255:0] next_q;
    integer i, j;
    integer neighbors;

    // Generate toroidal neighbor indices
    integer neighbor_idx_h[8] = {1, -1, 0, 0, 1, 1, -1, -1};
    integer neighbor_idx_v[8] = {0, 0, 1, -1, 1, -1, 1, -1};

    // Loop through each cell in the grid
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        neighbors = 0;

        // Calculate number of neighbors
        for (integer k = 0; k < 8; k = k + 1) begin
          integer h = (i + neighbor_idx_h[k] + 16) % 16;
          integer v = (j + neighbor_idx_v[k] + 16) % 16;
          neighbors = neighbors + q[h*16 + v];
        end

        // Update cell state
        if (load) begin
          q[i*16 + j] <= data[i*16 + j];
        end else begin
          if (neighbors <= 1 || neighbors >= 4) begin
            next_q[i*16 + j] = 0; // Cell becomes dead
          end else if (neighbors == 3) begin
            next_q[i*16 + j] = 1; // Cell becomes alive
          end else begin
            next_q[i*16 + j] = q[i*16 + j]; // Cell state remains the same
          end
        end
      end
    end

    // Update the grid at the next clock edge
    if (!load) begin
      q <= next_q;
    end
  end

endmodule