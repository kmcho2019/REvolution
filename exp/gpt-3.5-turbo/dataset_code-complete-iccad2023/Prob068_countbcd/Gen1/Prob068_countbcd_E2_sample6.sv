module BCDCounter (
  input clk,
  input reset,
  output reg [3:0] ena,
  output reg [3:0] q
);

always @(posedge clk) begin
  if (reset) begin
    q <= 4'b0000;
    ena <= 4'b0000;
  end else begin
    if (q == 4'b1001) begin
      q <= 4'b0000;
    end else begin
      q <= q + 4'b0001;
    end

    case (q)
      4'b0001, 4'b0010, 4'b0011: ena <= 4'b001;
      4'b0100, 4'b0101, 4'b0110, 4'b0111:  ena <= 4'b011;
      4'b1000, 4'b1001: ena <= 4'b101;
    endcase
  end
end

endmodule

module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [15:0] q_temp;

BCDCounter digit_ones (
  .clk(clk),
  .reset(reset),
  .q(q_temp[3:0]),
  .ena(ena[0])
);
BCDCounter digit_tens (
  .clk(clk),
  .reset(reset),
  .q(q_temp[7:4]),
  .ena(ena[1])
);
BCDCounter digit_hundreds (
  .clk(clk),
  .reset(reset),
  .q(q_temp[11:8]),
  .ena(ena[2])
);
BCDCounter digit_thousands (
  .clk(clk),
  .reset(reset),
  .q(q_temp[15:12]),
  .ena(ena[3])
);

always @(*) begin
  q = q_temp;
end

endmodule