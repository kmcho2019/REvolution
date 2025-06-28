module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// Next state logic for Y[0]
always @(*)
begin
  case({y, x})
    3'b0000: Y0 = 1'b0;
    3'b0001: Y0 = 1'b0;
    3'b0010: Y0 = 1'b0;
    3'b0011: Y0 = 1'b0;
    3'b0100: Y0 = 1'b1;
  endcase
end

// Output logic for z
always @(*)
begin
  case({y, x})
    3'b0011, 3'b0110: z = 1'b1;
    default: z = 1'b0;
  endcase
end

endmodule