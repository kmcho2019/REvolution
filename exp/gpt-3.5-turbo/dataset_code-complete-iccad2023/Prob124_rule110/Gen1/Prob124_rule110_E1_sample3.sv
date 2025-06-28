module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [513:0] q_extended; // Extend the array with two extra cells

  always @ (posedge clk) begin
    if (load) begin
      q_extended[1:512] <= data; // Load data if load signal is high
      q_extended[0] <= 1'b0; // Set boundary q[-1] to zero
      q_extended[513] <= 1'b0; // Set boundary q[512] to zero
    end else begin
      // Apply Rule 110 transition logic with explicit boundary handling
      for (int i = 0; i < 512; i = i + 1) begin
        q[i] <= ((q_extended[i] & ~q_extended[i+1]) | (~q_extended[i] & q_extended[i+2]));
      end
    end
  end

endmodule