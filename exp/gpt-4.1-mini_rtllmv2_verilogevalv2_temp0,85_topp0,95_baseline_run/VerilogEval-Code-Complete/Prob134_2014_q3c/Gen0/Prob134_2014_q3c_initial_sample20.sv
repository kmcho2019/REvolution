module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @(*) begin
  // Default outputs
  Y0 = 0;
  z = 0;

  // Output z depends only on present state y
  case (y)
    3'b011,
    3'b100: z = 1'b1;
    default: z = 1'b0;
  endcase

  // Y0 depends on present state y and input x
  case (y)
    3'b000: Y0 = (x == 1'b0) ? 1'b0 : 1'b1;
    3'b001: Y0 = (x == 1'b0) ? 1'b1 : 1'b0;
    3'b010: Y0 = (x == 1'b0) ? 1'b0 : 1'b1;
    3'b011: Y0 = (x == 1'b0) ? 1'b1 : 1'b0;
    3'b100: Y0 = (x == 1'b0) ? 1'b1 : 1'b0;
    default: Y0 = 1'b0; // For completeness
  endcase
end

endmodule