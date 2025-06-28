module TopModule (
  input clk,
  input [7:0] d,
  input areset,
  output reg [7:0] q
);

reg [7:0] q_temp;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    q_temp <= 8'b0;
  end else begin
    q_temp <= d;
  end
end

assign q = q_temp;

endmodule

module DFlipFlopWithReset (
  input clk,
  input d,
  input areset,
  output reg q
);

always @(posedge clk or posedge areset) begin
  if (areset) begin
    q <= 1'b0;
  end else begin
    q <= d;
  end
end

endmodule

module EightDFFsWithReset (
  input clk,
  input [7:0] d,
  input areset,
  output reg [7:0] q
);

DFlipFlopWithReset dff0(clk, d[0], areset, q[0]);
DFlipFlopWithReset dff1(clk, d[1], areset, q[1]);
DFlipFlopWithReset dff2(clk, d[2], areset, q[2]);
DFlipFlopWithReset dff3(clk, d[3], areset, q[3]);
DFlipFlopWithReset dff4(clk, d[4], areset, q[4]);
DFlipFlopWithReset dff5(clk, d[5], areset, q[5]);
DFlipFlopWithReset dff6(clk, d[6], areset, q[6]);
DFlipFlopWithReset dff7(clk, d[7], areset, q[7]);

endmodule