module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// State transition logic for Y[0]
always @*
begin
  case({y, x})
    6'b000000: Y0 = 1'b0;
    6'b000001: Y0 = 1'b1;
    6'b000010: Y0 = 1'b0;
    6'b000011: Y0 = 1'b1;
    6'b000100: Y0 = 1'b1;
    default: Y0 = 1'b0;
  endcase
end

// Output logic for z
always @*
begin
  case(y)
    3'b011, 3'b100: z = 1'b1;
    default: z = 1'b0;
  endcase
end

endmodule