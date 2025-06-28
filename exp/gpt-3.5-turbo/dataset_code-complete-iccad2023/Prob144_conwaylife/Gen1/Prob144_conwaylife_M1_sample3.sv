module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  // Cell update logic
  always @ (posedge clk) begin
    if (load) begin
      q <= data; // Load initial state
    end 
    else begin
      // Create temporary array to store next state
      reg [255:0] next_q;
      
      // Apply rules to update cell states
      integer i, j; // Using integer for loop indexing
      for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
          // Calculate number of live neighbors for cell (i,j)
          int neighbors = q[((i+1) & 15) * 16 + j] + q[((i-1) & 15) * 16 + j] +
                          q[i * 16 + ((j+1) & 15)] + q[i * 16 + ((j-1) & 15)] +
                          q[((i+1) & 15) * 16 + ((j+1) & 15)] + q[((i+1) & 15) * 16 + ((j-1) & 15)] +
                          q[((i-1) & 15) * 16 + ((j+1) & 15)] + q[((i-1) & 15) * 16 + ((j-1) & 15)];
          
          // Update cell state based on the number of neighbors
          if (neighbors == 3 || (neighbors == 2 && q[i*16 + j])) begin
            next_q[i*16 + j] = 1;  // Cell becomes alive
          end
          else begin
            next_q[i*16 + j] = 0;  // Cell becomes dead
          end
        end
      end
      
      // Update current state with next state
      q <= next_q;
    end
  end

endmodule