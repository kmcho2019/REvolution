module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load input data
    end else begin
      // Calculate next state for each cell based on Rule 90
      for (int i = 0; i < 512; i = i + 1) begin
        if (i == 0) begin
          q[i] <= q[1] ^ 0; // Left boundary, assume left neighbor is 0
        end else if (i == 511) begin
          q[i] <= 0 ^ q[510]; // Right boundary, assume right neighbor is 0
        end else begin
          q[i] <= q[i-1] ^ q[i+1]; // XOR of neighbors
        end
      end
    end
  end
  
endmodule