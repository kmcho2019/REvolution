module TopModule (
  input clk,
  input reset,
  output reg [9:0] q
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 10'b0; // Reset the counter to 0
    end else begin
      if (q == 10'b1111101001) begin // Check if the counter is about to overflow
        q <= 10'b0; // Reset the counter to 0 after reaching 999
      end else begin
        q <= q + 1; // Increment the counter by 1
      end
    end
  end
  
endmodule