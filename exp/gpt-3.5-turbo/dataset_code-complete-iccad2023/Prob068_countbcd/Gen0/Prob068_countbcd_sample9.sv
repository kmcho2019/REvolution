module BCD_Counter (
  input clk,
  input reset,
  input enable,
  output reg [3:0] q,
  output reg increment
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 4'b0000;
    increment <= 1'b0;
  end
  else if (enable && (q == 4'b1001)) begin
    q <= 4'b0000;
    increment <= 1'b1;
  end
  else if (enable) begin
    q <= q + 1;
    increment <= 1'b0;
  end
  else begin
    increment <= 1'b0;
  end
end

endmodule

module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

reg [3:0] q1, q2, q3, q4;
reg enable2, enable3, enable4;

BCD_Counter u1 (.clk(clk), .reset(reset), .enable(1), .q(q1), .increment(enable2));
BCD_Counter u2 (.clk(clk), .reset(reset), .enable(enable2), .q(q2), .increment(enable3));
BCD_Counter u3 (.clk(clk), .reset(reset), .enable(enable3), .q(q3), .increment(enable4));
BCD_Counter u4 (.clk(clk), .reset(reset), .enable(enable4), .q(q4), .increment(ena[1]));

assign ena = {enable2, enable3, enable4};

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 16'h0000;
  end
  else begin
    if (ena[1] && q1 == 4'b1001) begin
      enable2 <= 1;
    end
    if (ena[2] && q2 == 4'b1001) begin
      enable3 <= 1;
    end
    if (ena[3] && q3 == 4'b1001) begin
      enable4 <= 1;
    end
    
    q[3:0] <= q1;
    q[7:4] <= q2;
    q[11:8] <= q3;
    q[15:12] <= q4;
  end
end

endmodule