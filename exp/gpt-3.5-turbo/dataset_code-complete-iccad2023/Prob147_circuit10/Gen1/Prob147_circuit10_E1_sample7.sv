module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg prev_a;

always @(*) begin
  if (a & !prev_a) begin
    q = 1;
    state = 1;
  end else begin
    q = 0;
    state = 0;
  end
  prev_a = a;
end

endmodule