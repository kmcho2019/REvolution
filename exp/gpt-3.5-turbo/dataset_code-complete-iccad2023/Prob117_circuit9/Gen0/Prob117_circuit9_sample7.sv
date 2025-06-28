module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [2:0] next_q;

always @ (posedge clk) begin
  if (a == 1 && q == 0) begin
    next_q <= 1;
  end
  else if (a == 0) begin
    next_q <= q + 1;
  end
  else begin
    next_q <= q;
  end
end

always @ (*) begin
  q <= next_q;
end

endmodule