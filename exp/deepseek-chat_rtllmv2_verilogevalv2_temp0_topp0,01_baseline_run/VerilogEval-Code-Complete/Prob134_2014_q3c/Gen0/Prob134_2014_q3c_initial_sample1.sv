module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

  always @(*) begin
    // Logic for Y0
    case ({x, y})
      4'b0000: Y0 = 1'b0;  // x=0, y=000
      4'b0001: Y0 = 1'b0;  // x=0, y=001
      4'b0010: Y0 = 1'b0;  // x=0, y=010
      4'b0011: Y0 = 1'b1;  // x=0, y=011
      4'b0100: Y0 = 1'b1;  // x=0, y=100
      
      4'b1000: Y0 = 1'b1;  // x=1, y=000
      4'b1001: Y0 = 1'b0;  // x=1, y=001
      4'b1010: Y0 = 1'b0;  // x=1, y=010
      4'b1011: Y0 = 1'b0;  // x=1, y=011
      4'b1100: Y0 = 1'b0;  // x=1, y=100
      default: Y0 = 1'b0;
    endcase

    // Logic for z
    case (y)
      3'b000: z = 1'b0;
      3'b001: z = 1'b0;
      3'b010: z = 1'b0;
      3'b011: z = 1'b1;
      3'b100: z = 1'b1;
      default: z = 1'b0;
    endcase
  end

endmodule