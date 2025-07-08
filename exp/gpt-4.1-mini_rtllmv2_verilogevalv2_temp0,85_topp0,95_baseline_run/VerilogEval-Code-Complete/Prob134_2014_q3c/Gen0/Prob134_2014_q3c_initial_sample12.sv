module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

  always @(*) begin
    // Assign z
    z = (~y[2] & y[1] & y[0]) | (y[2] & ~y[1] & ~y[0]);

    // Assign Y0 based on present state y and input x
    case ({y, x})
      4'b0000: Y0 = 1'b0; // y=000,x=0 next=000 -> Y0=0
      4'b0001: Y0 = 1'b1; // y=000,x=1 next=001 -> Y0=1
      4'b0010: Y0 = 1'b1; // y=001,x=0 next=001 -> Y0=1
      4'b0011: Y0 = 1'b0; // y=001,x=1 next=100 -> Y0=0
      4'b0100: Y0 = 1'b0; // y=010,x=0 next=010 -> Y0=0
      4'b0101: Y0 = 1'b1; // y=010,x=1 next=001 -> Y0=1
      4'b0110: Y0 = 1'b1; // y=011,x=0 next=001 -> Y0=1
      4'b0111: Y0 = 1'b0; // y=011,x=1 next=010 -> Y0=0
      4'b1000: Y0 = 1'b1; // y=100,x=0 next=011 -> Y0=1
      4'b1001: Y0 = 1'b0; // y=100,x=1 next=100 -> Y0=0
      default: Y0 = 1'b0; // default to 0 for unused states
    endcase
  end

endmodule