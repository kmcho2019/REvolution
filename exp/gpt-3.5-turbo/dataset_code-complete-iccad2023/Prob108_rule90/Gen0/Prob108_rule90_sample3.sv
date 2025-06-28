module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Handling left boundary (q[-1] = 0)
      q[0] = data[1];
      
      // Calculate the next state for internal cells
      for (int i = 1; i < 511; i = i + 1) begin
        q[i] = data[i-1] ^ data[i+1];
      end

      // Handling right boundary (q[512] = 0)
      q[511] = data[510];
    end
  end

endmodule