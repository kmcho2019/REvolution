module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

  always @(*) begin
    // Output z is 1 when present state is 011 or 100
    if (y == 3'b011 || y == 3'b100)
      z = 1'b1;
    else
      z = 1'b0;

    // Determine Y0 based on present state y and input x
    case ({y, x})
      4'b0000: Y0 = 1'b0; // y=000, x=0 -> next Y0=0
      4'b0001: Y0 = 1'b1; // y=000, x=1 -> next Y0=1
      4'b0010: Y0 = 1'b1; // y=001, x=0 -> next Y0=1
      4'b0011: Y0 = 1'b0; // y=001, x=1 -> next Y0=0
      4'b0100: Y0 = 1'b0; // y=010, x=0 -> next Y0=0
      4'b0101: Y0 = 1'b1; // y=010, x=1 -> next Y0=1
      4'b0110: Y0 = 1'b1; // y=011, x=0 -> next Y0=1
      4'b0111: Y0 = 1'b0; // y=011, x=1 -> next Y0=0
      4'b1000: Y0 = 1'b1; // y=100, x=0 -> next Y0=1
      4'b1001: Y0 = 1'b0; // y=100, x=1 -> next Y0=0
      default: Y0 = 1'b0;
    endcase
  end

endmodule