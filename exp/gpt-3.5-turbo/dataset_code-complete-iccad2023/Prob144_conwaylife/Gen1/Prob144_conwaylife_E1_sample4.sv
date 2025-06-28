module TopModule (
  input clk,       // Clock input
  input load,      // Load input for initial data
  input [255:0] data,  // Initial data
  output reg [255:0] q  // Output grid state
);

// Calculate the number of alive neighbors for each cell
always @ (*) begin
  reg [255:0] neighbor_count; // To store the number of neighbors for each cell

  // Pre-calculate the indices of neighboring cells for each cell to exploit parallelism
  // Using the modulo operation to handle toroidal wrapping
  for (int i = 0; i < 256; i = i + 1) begin
    neighbor_count[i] = q[(i + 1) % 16 + (i/16) * 16] + q[(i - 1 + 16) % 16 + (i/16) * 16] +
                        q[i + ((i + 16) % 256)] + q[i + ((i - 16 + 256) % 256)] +
                        q[(i + 1) % 16 + ((i + 16) % 256)] + q[(i + 1) % 16 + ((i - 16 + 256) % 256)] +
                        q[(i - 1 + 16) % 16 + ((i + 16) % 256)] + q[(i - 1 + 16) % 16 + ((i - 16 + 256) % 256)];
  end

  // Update the cell states based on the number of neighbors concurrently
  for (int j = 0; j < 256; j = j + 1) begin
    case(neighbor_count[j])
      0, 1: q[j] <= 0;
      2: q[j] <= q[j];
      3: q[j] <= 1;
      default: q[j] <= 0;
    endcase
  end
end

// Load initial state at the rising edge of the clock
always @(posedge clk) begin
  if (load) begin
    q <= data;
  end
end

endmodule