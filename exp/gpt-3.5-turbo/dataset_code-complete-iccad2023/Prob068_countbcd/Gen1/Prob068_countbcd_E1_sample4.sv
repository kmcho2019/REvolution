module BCD_Counter (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg increment;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 16'b0000;
    ones <= 4'b0000;
    tens <= 4'b0000;
    hundreds <= 4'b0000;
    thousands <= 4'b0000;
    increment <= 1'b0;
  end 
  else begin
    if (ones == 4'b1001) begin
      ones <= 4'b0000;
      increment <= 1'b1;
    end 
     else if (increment) begin
      ones <= ones + 1;
      increment <= 1'b0;
    end

    if (tens == 4'b1001) begin
      tens <= 4'b0000;
      increment <= 1'b1;
    end 
    else if (ones == 4'b1001) begin
      tens <= tens + 1;
    end

    if (hundreds == 4'b1001) begin
      hundreds <= 4'b0000;
      increment <= 1'b1;
    end 
    else if (tens == 4'b1001) begin
      hundreds <= hundreds + 1;
    end

    if (thousands == 4'b1001) begin
      thousands <= 4'b0000;
      increment <= 1'b1;
    end 
    else if (hundreds == 4'b1001) begin
      thousands <= thousands + 1;
    end

    q <= {thousands, hundreds, tens, ones};
    ena <= {increment, tens == 4'b1001, hundreds == 4'b1001};
  end
end

endmodule