module BCD_Counter (
  input clk,
  input reset,
  input ena_ones,
  input ena_tens,
  input ena_hundreds,
  output reg [15:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
    end else begin
      if (ena_ones && (q[3:0] < 4'b1001))
        q[3:0] <= q[3:0] + 4'b0001;
      if (q[3:0] == 4'b1001)
        q[3:0] <= 4'b0000;
      
      if (ena_tens && (q[7:4] < 4'b1001))
        q[7:4] <= q[7:4] + 4'b0001;
      if (q[7:4] == 4'b1001)
        q[7:4] <= 4'b0000;
      
      if (ena_hundreds && (q[11:8] < 4'b1001))
        q[11:8] <= q[11:8] + 4'b0001;
      if (q[11:8] == 4'b1001)
        q[11:8] <= 4'b0000;

      if (q[15:12] < 4'b1001)
        q[15:12] <= q[15:12] + 4'b0001;
      else
        q[15:12] <= 4'b0000;
    end
  end

endmodule

module TopModule (
  input clk,
  input reset,
  output ena_ones,
  output ena_tens,
  output ena_hundreds,
  output reg [15:0] q
);

  reg [2:0] count_enable;

  always @(*) begin
    ena_ones = count_enable[0];
    ena_tens = count_enable[1];
    ena_hundreds = count_enable[2];
  end

  always @(posedge clk) begin
    if (reset)
      count_enable <= 3'b0;
    else
      count_enable <= count_enable + 1;
  end

  BCD_Counter bcd_counter (
    .clk(clk),
    .reset(reset),
    .ena_ones(ena_ones),
    .ena_tens(ena_tens),
    .ena_hundreds(ena_hundreds),
    .q(q)
  );

endmodule