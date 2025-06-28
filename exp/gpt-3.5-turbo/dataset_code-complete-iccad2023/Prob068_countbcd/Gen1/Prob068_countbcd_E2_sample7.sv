module BCDCounter (
  input clk,
  input reset,
  input en,
  output reg [3:0] q
);

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    q <= 4'b0000;
  end
  else if ((q == 4'b1001) && en) begin
    q <= 4'b0000;
  end
  else if (en) begin
    q <= q + 4'b0001;
  end
end

endmodule

module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

BCDCounter ones_digit (
  .clk(clk),
  .reset(reset),
  .en(1'b1),
  .q(q[3:0])
);

BCDCounter tens_digit (
  .clk(clk),
  .reset(reset),
  .en(ena[1]),
  .q(q[7:4])
);

BCDCounter hundreds_digit (
  .clk(clk),
  .reset(reset),
  .en(ena[2]),
  .q(q[11:8])
);

BCDCounter thousands_digit (
  .clk(clk),
  .reset(reset),
  .en(ena[3]),
  .q(q[15:12])
);

assign q = {thousands_digit.q, hundreds_digit.q, tens_digit.q, ones_digit.q};

endmodule