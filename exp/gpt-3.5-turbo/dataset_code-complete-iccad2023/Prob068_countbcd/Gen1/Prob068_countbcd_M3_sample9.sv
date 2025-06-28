module BCD_Counter (
  input clk,
  input reset,
  input [2:0] ena,
  output reg [15:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
    end else begin
      if (ena[0] && q[3:0] == 4'b1001)
        q[3:0] <= 4'b0000;
      else if (ena[0])
        q[3:0] <= q[3:0] + 4'b0001;
      
      if (ena[1] && q[7:4] == 4'b1001)
        q[7:4] <= 4'b0000;
      else if (ena[1])
        q[7:4] <= q[7:4] + 4'b0001;
      
      if (ena[2] && q[11:8] == 4'b1001)
        q[11:8] <= 4'b0000;
      else if (ena[2])
        q[11:8] <= q[11:8] + 4'b0001;
      
      if (q[15:12] == 4'b1001)
        q[15:12] <= 4'b0000;
      else
        q[15:12] <= q[15:12] + 4'b0001;
    end
  }

endmodule

module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

  reg [2:0] ena_internal;

  always @* begin
    ena_internal[0] = ena[1];
    ena_internal[1] = ena[2];
    ena_internal[2] = ena[3];
  end

  BCD_Counter bcd_counter (
    .clk(clk),
    .reset(reset),
    .ena(ena_internal),
    .q(q)
  );

endmodule