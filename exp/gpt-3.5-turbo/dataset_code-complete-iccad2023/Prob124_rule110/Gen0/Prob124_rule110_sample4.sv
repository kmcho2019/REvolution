module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load data if load signal is high
    end else begin
      // Apply Rule 110 for each cell except boundaries
      for (int i = 1; i < 511; i = i + 1) begin
        if (q[i-1] & q[i] & q[i+1])
          q[i] <= 1'b0;
        else if (q[i-1] & q[i] & ~q[i+1])
          q[i] <= 1'b1;
        else if (q[i-1] & ~q[i] & q[i+1])
          q[i] <= 1'b1;
        else if (q[i-1] & ~q[i] & ~q[i+1])
          q[i] <= 1'b0;
        else if (~q[i-1] & q[i] & q[i+1])
          q[i] <= 1'b1;
        else if (~q[i-1] & q[i] & ~q[i+1])
          q[i] <= 1'b1;
        else if (~q[i-1] & ~q[i] & q[i+1])
          q[i] <= 1'b1;
        else if (~q[i-1] & ~q[i] & ~q[i+1])
          q[i] <= 1'b0;
      end
    end
  end

endmodule