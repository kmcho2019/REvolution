module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  reg [255:0] q_next;

  // Calculate the index offsets for neighbors
  localparam RIGHT = 1;
  localparam LEFT = -1;
  localparam UP = 16;
  localparam DOWN = -16;

  always @* begin
    // Calculate the number of neighbors for each cell
    for (int idx = 0; idx < 256; idx = idx + 1) begin
      int neighbors = 0;
      neighbors = neighbors + q[(idx + RIGHT) & 255];
      neighbors = neighbors + q[(idx + LEFT) & 255];
      neighbors = neighbors + q[(idx + UP) & 255];
      neighbors = neighbors + q[(idx + DOWN) & 255];
      neighbors = neighbors + q[(idx + RIGHT + UP) & 255];
      neighbors = neighbors + q[(idx + LEFT + UP) & 255];
      neighbors = neighbors + q[(idx + RIGHT + DOWN) & 255];
      neighbors = neighbors + q[(idx + LEFT + DOWN) & 255];

      // Update cell state based on the number of neighbors
      if (neighbors == 3)
        q_next[idx] = 1;
      else if (neighbors == 2)
        q_next[idx] = q[idx];
      else
        q_next[idx] = 0;
    end
  end

  // Synchronize the update of q
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= q_next;
    end
  end

endmodule