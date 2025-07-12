module TopModule(
  input clk,
  input a,
  output reg q
);

reg prev_a;

always @(posedge clk) begin
  prev_a <= a;
  if (prev_a == 1 && a == 1 && q == 1) begin
    q <= 0;
  end else if (prev_a == 0 && a == 0 && q == 0) begin
    q <= 1;
  end else if (prev_a == 0 && a == 0 && q == 1) begin
    q <= 1;
  end else if (prev_a == 1 && a == 1 && q == 0) begin
    q <= 0;
  end else if (prev_a == 0 && a == 1) begin
    // do nothing
  end else if (prev_a == 1 && a == 0) begin
    // do nothing
  end
end

initial begin
  prev_a = 0;
  q = 1;
end

endmodule