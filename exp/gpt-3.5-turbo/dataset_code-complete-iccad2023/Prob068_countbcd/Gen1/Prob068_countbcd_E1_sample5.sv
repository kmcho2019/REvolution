module BCDCounter (
  input clk,
  input reset,
  output reg [3:0] ena,
  output reg [15:0] q
);

reg [3:0] counter = 4'b0;

always @ (posedge clk) begin
  if (reset) begin
    counter <= 4'b0;
  end else begin
    if (counter == 4'b1001) begin
      counter <= 4'b0;
    end else begin
      counter <= counter + 1;
    end
  end
end

assign q = {counter, counter, counter, counter};

always @* begin
  if (counter >= 6) // Threshold value for tens digit
    ena[1] = 1;
  else
    ena[1] = 0;
    
  if (counter >= 9) // Threshold value for hundreds digit
    ena[2] = 1;
  else
    ena[2] = 0;

  if (counter >= 9) // Threshold value for thousands digit
    ena[3] = 1;
  else
    ena[3] = 0;
end
    
endmodule

module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

BCDCounter counter_inst (
  .clk(clk),
  .reset(reset),
  .q(q),
  .ena(ena)
);

endmodule