module TopModule (
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @*
begin
  // State transition logic for Y[0]
  case ({y, x})
    6'b000000: Y0 = 1'b0; // y=000, x=0 -> Y[2:0]=000
    6'b000001: Y0 = 1'b1; // y=000, x=1 -> Y[2:0]=001
    6'b000010: Y0 = 1'b0; // y=001, x=0 -> Y[2:0]=001
    6'b000011: Y0 = 1'b0; // y=001, x=1 -> Y[2:0]=100
    6'b000100: Y0 = 1'b1; // y=010, x=1 -> Y[2:0]=001
    default: Y0 = 1'b0;    // Default case
  endcase

  // Output logic for z
  case (y)
    3'b011: z = 1'b1; // Present state is 011, output z = 1
    3'b100: z = 1'b1; // Present state is 100, output z = 1
    default: z = 1'b0; // Default case
  endcase
end

endmodule