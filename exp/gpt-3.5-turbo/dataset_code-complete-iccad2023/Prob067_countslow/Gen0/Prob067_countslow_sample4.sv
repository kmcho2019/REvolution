module TopModule (
  input clk,
  input slowena,
  input reset,
  output reg [3:0] q
);

reg [3:0] count_next, count_reg;
reg slowclk;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    count_next <= 4'b0000;
  end
  else begin
    count_next <= slowclk ? count_reg + 1 : count_reg;
  end
end

always @(posedge clk) begin
  if (slowena) begin
    slowclk <= ~slowclk;
  end
end

always @(posedge clk) begin
  count_reg <= count_next;
end

assign q = count_reg;

endmodule