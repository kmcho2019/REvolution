module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_pos, q_neg;
reg toggle; // To toggle between positive and negative edge triggers

always @(posedge clk or negedge clk)
  toggle <= ~toggle;

always @(posedge clk)
begin
  if (toggle)
    q_pos <= d;
end

always @(negedge clk)
begin
  if (~toggle)
    q_neg <= d;
end

always @(*)
begin
  if (toggle)
    q <= q_pos;
  else
    q <= q_neg;
end

endmodule