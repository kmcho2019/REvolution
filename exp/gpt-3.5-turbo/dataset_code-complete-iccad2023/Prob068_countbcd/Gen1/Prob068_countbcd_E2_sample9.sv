module BCD_Counter (
  input clk, 
  input reset,
  input [3:1] ena,
  output reg [15:0] q
);

reg [3:0] digit[3:0]; // Array to hold the current value of each digit

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    q <= 16'b0;
    digit[0] <= 4'b0;
    digit[1] <= 4'b0;
    digit[2] <= 4'b0;
    digit[3] <= 4'b0;
  end else begin
    if (ena[0]) begin
      if (digit[0] == 4'b1001) digit[0] <= 4'b0;
      else digit[0] <= digit[0] + 1;
    end
    if (ena[1]) begin
      if (digit[1] == 4'b1001) digit[1] <= 4'b0;
      else digit[1] <= digit[1] + 1;
    end
    if (ena[2]) begin
      if (digit[2] == 4'b1001) digit[2] <= 4'b0;
      else digit[2] <= digit[2] + 1;
    end
    if (digit[3] == 4'b1001) digit[3] <= 4'b0;
    else digit[3] <= digit[3] + 1;
    
    q <= {digit[3], digit[2], digit[1], digit[0]};
  end
end

endmodule