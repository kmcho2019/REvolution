module TopModule (
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @(*)
begin
  case({y, x})
    3'b000_0: Y0 = 1'b0; z = 1'b0;
    3'b000_1: Y0 = 1'b1; z = 1'b0;
    3'b001_0: Y0 = 1'b0; z = 1'b0;
    3'b001_1: Y0 = 1'b0; z = 1'b0;
    3'b010_0: Y0 = 1'b0; z = 1'b0;
    3'b010_1: Y0 = 1'b1; z = 1'b0;
    3'b011_0: Y0 = 1'b1; z = 1'b1;
    3'b011_1: Y0 = 1'b0; z = 1'b1;
    3'b100_0: Y0 = 1'b1; z = 1'b1;
    3'b100_1: Y0 = 1'b0; z = 1'b1;
    default: Y0 = 1'b0; z = 1'b0;
  endcase
end

endmodule