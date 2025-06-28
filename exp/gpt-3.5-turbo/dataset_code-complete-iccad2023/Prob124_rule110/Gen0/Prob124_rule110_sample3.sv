module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  
  always @ (posedge clk) begin
    if (load) begin
      q <= data; // Load initial state from input data
    end else begin
      // Apply Rule 110 for each cell in the array
      for (int i = 0; i < 512; i = i + 1) begin
        if (i == 0) begin
          // Left boundary condition
          q[i] <= (q[i] & ~q[i+1]);
        end else if (i == 511) begin
          // Right boundary condition
          q[i] <= (q[i-1] & q[i]);
        end else begin
          // Update cell based on its neighbors
          q[i] <= ((q[i-1] & q[i] & ~q[i+1]) | 
                   (q[i-1] & ~q[i] & q[i+1]) | 
                   (~q[i-1] & q[i] & q[i+1]) | 
                   (~q[i-1] & ~q[i] & ~q[i+1]));
        end
      end
    end
  end

endmodule