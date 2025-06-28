module BCD_Digit (
  input clk, 
  input reset, 
  input enable,
  output reg [3:0] q 
);

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    q <= 4'b0000;
  end else begin
    if (enable) begin
      if (q == 4'b1001) q <= 4'b0000;
      else q <= q + 1;
    end
  end
end

endmodule

module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

reg [2:0] ena_temp;
reg [3:0] q_temp[3:0];

BCD_Digit digit0 (.clk(clk), .reset(reset), .enable(1'b1), .q(q_temp[0]));
BCD_Digit digit1 (.clk(clk), .reset(reset), .enable(ena_temp[0]), .q(q_temp[1]));
BCD_Digit digit2 (.clk(clk), .reset(reset), .enable(ena_temp[1]), .q(q_temp[2]));
BCD_Digit digit3 (.clk(clk), .reset(reset), .enable(ena_temp[2]), .q(q_temp[3]));

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    q <= 16'b0;
    ena_temp <= 3'b0;
  end else begin
    ena_temp <= ena;
    if (ena_temp[0]) q_temp[0] <= q_temp[0] + 1;
    if (ena_temp[1]) q_temp[1] <= q_temp[1] + 1;
    if (ena_temp[2]) q_temp[2] <= q_temp[2] + 1;
    q_temp[3] <= q_temp[3] + 1;
    q <= {q_temp[3], q_temp[2], q_temp[1], q_temp[0]};
  end
end

endmodule