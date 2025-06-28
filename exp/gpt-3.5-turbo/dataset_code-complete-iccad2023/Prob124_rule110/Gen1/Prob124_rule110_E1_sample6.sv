module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load data when load is active
    end else begin
      // Handle left boundary
      int left_boundary = 1'b0;

      for (int i = 0; i < 512; i = i + 1) begin
        // Define the boundaries where the two adjacent cell states are 0
        int left = (i == 0) ? left_boundary : q[i-1];
        int right = (i == 511) ? 1'b0 : q[i+1];
        
        // Implement Rule 110 with bitwise operations
        int rule110 = (left & q[i] & ~right) | 
                      (left & ~q[i] & right) | 
                      (~left & q[i] & right) | 
                      (~left & ~q[i] & ~right);
        
        q[i] <= rule110; // Update cell state based on Rule 110
      end
    end
  end

endmodule