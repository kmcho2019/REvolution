module BCDCounter (
  input clk,
  input reset,
  output reg [3:0] ena,
  output reg [3:0] q
);

always @ (posedge clk) begin
  if (reset) begin
    q <= 4'b0;
    ena <= 4'b0;
  end else begin
    if (q == 4'b1001)
      q <= 4'b0;
    else
      q <= q + 1;

    case (q)
      4'b0001: ena <= 4'b001;
      4'b0010: ena <= 4'b010;
      4'b0011: ena <= 4'b100;
      default: ena <= 4'b0;
    endcase
  end
end

endmodule

module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

reg [3:0] ena_temp;
reg [15:0] q_temp;

BCDCounter first_digit (
  .clk(clk),
  .reset(reset),
  .q(q_temp[3:0]),
  .ena(ena_temp[1])
);

BCDCounter second_digit (
  .clk(clk),
  .reset(reset),
  .q(q_temp[7:4]),
  .ena(ena_temp[2])
);

BCDCounter third_digit (
  .clk(clk),
  .reset(reset),
  .q(q_temp[11:8]),
  .ena(ena_temp[3])
);

BCDCounter fourth_digit (
  .clk(clk),
  .reset(reset),
  .q(q_temp[15:12]),
  .ena(ena_temp[4])
);

always @(*) begin
  q = q_temp;
  ena = ena_temp;
end

endmodule