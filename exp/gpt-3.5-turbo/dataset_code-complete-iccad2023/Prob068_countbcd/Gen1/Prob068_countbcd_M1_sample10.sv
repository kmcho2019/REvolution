module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
    end else begin
      if (ena[0]) begin
        if (q[3:0] == 4'b1001)
          q[3:0] <= 4'b0000;
        else
          q[3:0] <= q[3:0] + 4'b0001;
      end
      if (ena[1]) begin
        if (q[7:4] == 4'b1001)
          q[7:4] <= 4'b0000;
        else
          q[7:4] <= q[7:4] + 4'b0001;
      end
      if (ena[2]) begin
        if (q[11:8] == 4'b1001)
          q[11:8] <= 4'b0000;
        else
          q[11:8] <= q[11:8] + 4'b0001;
      end
      if (q[15:12] == 4'b1001)
        q[15:12] <= 4'b0000;
      else
        q[15:12] <= q[15:12] + 4'b0001;
    end
  end

endmodule