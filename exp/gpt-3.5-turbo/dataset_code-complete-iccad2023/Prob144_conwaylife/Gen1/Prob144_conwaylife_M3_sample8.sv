module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  always @ (posedge clk) begin
    if (load) begin
      q <= data; // Load initial state
    end else begin
      integer i, j;
      reg [255:0] next_q;

      // Calculate neighbors and update cell state
      for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
          int alive_neighbors = 
            q[i*16 + ((j+1) & 15)] + q[i*16 + ((j-1) & 15)] + q[((i+1) & 15) * 16 + j] +
            q[((i-1) & 15) * 16 + j] + q[((i+1) & 15) * 16 + ((j+1) & 15)] +
            q[((i+1) & 15) * 16 + ((j-1) & 15)] + q[((i-1) & 15) * 16 + ((j+1) & 15)] +
            q[((i-1) & 15) * 16 + ((j-1) & 15)];
          
          if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
            next_q[i*16 + j] = 0; // Cell becomes 0
          end else if (alive_neighbors == 3) begin
            next_q[i*16 + j] = 1; // Cell becomes 1
          end else begin
            next_q[i*16 + j] = q[i*16 + j]; // Cell state does not change
          end
        end
      end

      q <= next_q; // Update cell state
    end

  end
endmodule