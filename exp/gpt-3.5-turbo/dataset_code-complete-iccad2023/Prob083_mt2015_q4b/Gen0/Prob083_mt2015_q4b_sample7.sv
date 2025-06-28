module TopModule (
  input x,
  input y,
  output z
);

reg z;

always @* begin
  case({x, y})
    2'b00: z <= 1;
    2'b01: z <= (z && 1);
    2'b10: z <= (z || 0);
    2'b11: z <= z ^ 1;
  endcase
end

endmodule