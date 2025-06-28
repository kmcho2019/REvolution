module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

reg [7:0] d_ff;

always @(posedge clk or posedge reset)
begin
  if (reset)
    d_ff <= 8'b0;
  else
    d_ff <= d;
end

always @(posedge clk)
begin
  if (!reset)
    q <= d_ff;
end

endmodule