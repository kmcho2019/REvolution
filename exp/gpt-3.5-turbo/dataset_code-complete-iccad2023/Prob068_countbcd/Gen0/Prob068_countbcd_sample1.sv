module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

  // Individual BCD incrementers for each digit
  BCDIncrementer digit0(.clk(clk), .reset(reset), .in(q[3:0]), .out(q[3:0]));
  BCDIncrementer digit1(.clk(clk), .reset(reset), .in(q[7:4]), .out(q[7:4]), .enable(ena[1]));
  BCDIncrementer digit2(.clk(clk), .reset(reset), .in(q[11:8]), .out(q[11:8]), .enable(ena[2]));
  BCDIncrementer digit3(.clk(clk), .reset(reset), .in(q[15:12]), .out(q[15:12]), .enable(ena[3]));

  always @ (posedge clk) begin
    if (reset) begin
      q <= 16'h0000;
      ena <= 3'b000;
    end
    else begin
      // Increment least significant digit
      q[3:0] <= q[3:0] + 1;

      // Handle BCD carry
      if (q[3:0] == 4'b1010) begin
        q[3:0] <= 4'b0000;
        ena[1] <= 1;
      end

      // Increment tens digit
      if (ena[1]) begin
        q[7:4] <= q[7:4] + 1;
        ena[1] <= 0;
      end

      // Handle BCD carry
      if (q[7:4] == 4'b1010) begin
        q[7:4] <= 4'b0000;
        ena[2] <= 1;
      end

      // Increment hundreds digit
      if (ena[2]) begin
        q[11:8] <= q[11:8] + 1;
        ena[2] <= 0;
      end

      // Handle BCD carry
      if (q[11:8] == 4'b1010) begin
        q[11:8] <= 4'b0000;
        ena[3] <= 1;
      end

      // Increment thousands digit
      if (ena[3]) begin
        q[15:12] <= q[15:12] + 1;
        ena[3] <= 0;
      end
    end
  end

endmodule