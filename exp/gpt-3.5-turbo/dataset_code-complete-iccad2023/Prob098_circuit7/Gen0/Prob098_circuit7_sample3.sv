module TopModule (
  input clk,
  input a,
  output reg q
);

reg q_next;

always @(posedge clk or negedge clk)
begin
  if (~clk) // Falling edge of clock
    q <= q_next;
end

always @*
begin
  case ({a, q})
    2'b00: q_next = 1'b1;
    2'b01: q_next = 1'b0;
    2'b10: q_next = 1'b1;
    default: q_next = q;
  endcase
end

endmodule