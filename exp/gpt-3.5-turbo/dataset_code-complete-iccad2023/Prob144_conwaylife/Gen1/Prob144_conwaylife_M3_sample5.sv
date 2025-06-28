module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] next_q;

always @(posedge clk) begin
  if (load) begin
    q <= data; // Load initial grid state
  end else begin
    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        int neighbors = q[((i+15)%16)*16 + (j+15)%16] + q[((i+15)%16)*16 + j] + q[((i+15)%16)*16 + (j+1)%16] +
                        q[(i*16 + (j+15)%16)] + q[(i*16 + (j+1)%16)] +
                        q[((i+1)%16)*16 + (j+15)%16] + q[((i+1)%16)*16 + j] + q[((i+1)%16)*16 + (j+1)%16];
        
        if (neighbors <= 1 || neighbors >= 4) begin
          next_q[i*16 + j] = 0; // Cell becomes dead
        end else if (neighbors == 3) begin
          next_q[i*16 + j] = 1; // Cell becomes alive
        end else begin
          next_q[i*16 + j] = q[i*16 + j]; // Cell state does not change
        end
      end
    end
    q <= next_q; // Update game state
  end
end

endmodule