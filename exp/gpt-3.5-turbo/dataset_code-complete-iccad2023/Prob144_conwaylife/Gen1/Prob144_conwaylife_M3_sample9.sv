module Cell (
  input clk,
  input [255:0] q,
  output reg [255:0] next_q
);

  always @(posedge clk) begin
    genvar i, j;
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        int neighbors = 0;
        if (q[i*16 + ((j+1) & 15)]) neighbors = neighbors + 1;          // Right Neighbor
        if (q[i*16 + ((j-1) & 15)]) neighbors = neighbors + 1;          // Left Neighbor
        if (q[((i+1) & 15) * 16 + j]) neighbors = neighbors + 1;        // Top Neighbor
        if (q[((i-1) & 15) * 16 + j]) neighbors = neighbors + 1;        // Bottom Neighbor
        if (q[((i+1) & 15) * 16 + ((j+1) & 15)]) neighbors = neighbors + 1;  // Top Right Neighbor
        if (q[((i+1) & 15) * 16 + ((j-1) & 15)]) neighbors = neighbors + 1;  // Top Left Neighbor
        if (q[((i-1) & 15) * 16 + ((j+1) & 15)]) neighbors = neighbors + 1;  // Bottom Right Neighbor
        if (q[((i-1) & 15) * 16 + ((j-1) & 15)]) neighbors = neighbors + 1;  // Bottom Left Neighbor

        if (neighbors == 3)
          next_q[i*16 + j] <= 1;
        else if (neighbors == 2)
          next_q[i*16 + j] <= q[i*16 + j];
        else
          next_q[i*16 + j] <= 0;
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

  Cell cell_inst (
    .clk(clk),
    .q(q),
    .next_q(q)  // Fix: Correct connection to update q based on next_q
  );

  always @(posedge clk) begin
    if (load)
      q <= data;
  end

endmodule