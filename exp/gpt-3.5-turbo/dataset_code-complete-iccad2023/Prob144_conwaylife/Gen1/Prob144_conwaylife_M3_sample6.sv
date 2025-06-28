module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

// Update game state every clock cycle
always @(posedge clk) begin
  if (load) begin
    q <= data;
  end else begin
    reg [15:0] next_q [15:0];
    integer neighbors;

    // Update cell states
    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        neighbors = q[((i+15)%16)*16 + (j+15)%16] + q[((i+15)%16)*16 + j] + q[((i+15)%16)*16 + (j+1)%16] +
                    q[(i*16 + (j+15)%16)] + q[(i*16 + (j+1)%16)] +
                    q[((i+1)%16)*16 + (j+15)%16] + q[((i+1)%16)*16 + j] + q[((i+1)%16)*16 + (j+1)%16];

        if (neighbors <= 1 || neighbors >= 4) begin
          next_q[i][j] = 0; // Cell becomes 0
        end else if (neighbors == 3) begin
          next_q[i][j] = 1; // Cell becomes 1
        end else begin
          next_q[i][j] = q[i][j]; // Cell state does not change
        end
      end
    end

    // Update q with next state
    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        q[i*16 + j] <= next_q[i][j];
      end
    end
  end
end

endmodule