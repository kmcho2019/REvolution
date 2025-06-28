module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [2:0] q_reg, q_next;
initial q_reg = 3'b4;

always @ (posedge clk) begin
  q_reg <= q_next;
end

always @* begin
  if (a == 1'b1 && q_reg == 3'b0) begin
    q_next = 3'b1;
  end
  else if (a == 1'b0) begin
    q_next = q_reg + 1;
  end
  else begin
    q_next = q_reg;
  end
end

assign q = q_reg;

endmodule