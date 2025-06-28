module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @* begin
  case({y, x})
    3'b0000: Y0 = 1'b0; // Next state when x=0
    3'b0001: Y0 = 1'b0; // Next state when x=1
    3'b0010: Y0 = 1'b0;
    3'b0011: Y0 = 1'b0;
    3'b0100: Y0 = 1'b0;
    3'b0101: Y0 = 1'b0;
    3'b0110: Y0 = 1'b0;
    3'b0111: Y0 = 1'b1;
    3'b1000: Y0 = 1'b0;
    3'b1001: Y0 = 1'b1;
    default: Y0 = 1'b0;
  endcase
end

always @* begin
  case({y, x})
    3'b0000: z = 1'b0; // Output when x=0
    3'b0001: z = 1'b0; // Output when x=1
    3'b0010: z = 1'b0;
    3'b0011: z = 1'b0;
    3'b0100: z = 1'b0;
    3'b0101: z = 1'b0;
    3'b0110: z = 1'b1;
    3'b0111: z = 1'b0;
    3'b1000: z = 1'b0;
    3'b1001: z = 1'b1;
    default: z = 1'b0;
  endcase
end

endmodule