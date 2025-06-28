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
      reg [511:0] next_q;

      // Implement Rule 110
      always @* begin
        next_q[0] = (q[0] & ~q[1]) | (~q[0] & q[1]);
        for (int i = 1; i < 511; i = i + 1) begin
          next_q[i] = (q[i-1] & q[i] & ~q[i+1]) | (q[i-1] & ~q[i] & q[i+1]) | (~q[i-1] & q[i] & q[i+1]) | (~q[i-1] & ~q[i] & ~q[i+1]);
        end
        next_q[511] = (~q[510] & q[511]) | (q[510] & ~q[511]);
      end

      q <= next_q;
    end
  end

endmodule