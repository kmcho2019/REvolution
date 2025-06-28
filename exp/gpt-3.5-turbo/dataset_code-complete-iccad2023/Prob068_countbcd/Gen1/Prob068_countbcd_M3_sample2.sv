module BCD_Digit (
  input clk, 
  input reset, 
  input enable,
  output reg [3:0] q 
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 4'b0000;
    end else begin
      if (enable && q != 4'b1001) begin
        q <= q + 1;
      end
    end
  end

endmodule

module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

  reg [2:0] ena_temp;
  reg [3:0] q_temp[3:0];

  BCD_Digit digits [3:0] (
    .clk(clk),
    .reset(reset),
    .enable({1, ena_temp}),
    .q(q_temp)
  );

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 16'b0;
      ena_temp <= 3'b0;
    end else begin
      ena_temp <= ena;
      for (int i = 0; i < 4; i = i + 1) begin
        if (ena_temp[i]) begin
          q_temp[i] <= q_temp[i] + 1;
        end
      end
      q <= {q_temp[3], q_temp[2], q_temp[1], q_temp[0]};
    end
  end

endmodule