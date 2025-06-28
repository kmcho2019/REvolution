module NeighborCounter (
  input [255:0] q,
  output reg [255:0] neighbor_count
);

  always @(*) begin
    // Loop through each cell in the grid
    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        int count = 0;

        // Calculate the number of neighbors for cell (i,j)
        if (q[((i-1+16) & 15)*16 + ((j-1+16) & 15)]) count = count + 1;      // Top-left
        if (q[((i-1+16) & 15)*16 + j]) count = count + 1;                    // Top-middle
        if (q[((i-1+16) & 15)*16 + ((j+1) & 15)]) count = count + 1;         // Top-right
        if (q[(i*16 + ((j-1+16) & 15))]) count = count + 1;                  // Middle-left
        if (q[(i*16 + ((j+1) & 15))]) count = count + 1;                     // Middle-right
        if (q[((i+1) & 15)*16 + ((j-1+16) & 15)]) count = count + 1;         // Bottom-left
        if (q[((i+1) & 15)*16 + j]) count = count + 1;                       // Bottom-middle
        if (q[((i+1) & 15)*16 + ((j+1) & 15)]) count = count + 1;            // Bottom-right

        neighbor_count[i*16 + j] = count;
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

  // Instantiate the NeighborCounter module
  NeighborCounter neighbor_counter (
    .q(q),
    .neighbor_count()
  );

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end
    else begin
      // Update cell states based on the number of neighbors
      for (int i = 0; i < 16; i = i + 1) begin
        for (int j = 0; j < 16; j = j + 1) begin
          case (neighbor_counter[i*16 + j])
            0, 1: q[i*16 + j] <= 1'b0;  // Cell becomes dead
            3: q[i*16 + j] <= 1'b1;     // Cell becomes alive
            default: q[i*16 + j] <= q[i*16 + j]; // Cell state does not change
          endcase
        end
      end
    end
  end

endmodule