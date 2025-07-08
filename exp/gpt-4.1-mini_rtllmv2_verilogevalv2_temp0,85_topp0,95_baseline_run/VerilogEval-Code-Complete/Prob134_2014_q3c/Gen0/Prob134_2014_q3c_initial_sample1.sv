module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @(*) begin
  case (y)
    3'b000: begin
      z = 1'b0;
      if (x == 1'b0)
        Y0 = 1'b0;  // Next state 000 LSB
      else
        Y0 = 1'b1;  // Next state 001 LSB
    end
    3'b001: begin
      z = 1'b0;
      if (x == 1'b0)
        Y0 = 1'b1;  // Next state 001 LSB
      else
        Y0 = 1'b0;  // Next state 100 LSB
    end
    3'b010: begin
      z = 1'b0;
      if (x == 1'b0)
        Y0 = 1'b0;  // Next state 010 LSB
      else
        Y0 = 1'b1;  // Next state 001 LSB
    end
    3'b011: begin
      z = 1'b1;
      if (x == 1'b0)
        Y0 = 1'b1;  // Next state 001 LSB
      else
        Y0 = 1'b0;  // Next state 010 LSB
    end
    3'b100: begin
      z = 1'b1;
      if (x == 1'b0)
        Y0 = 1'b1;  // Next state 011 LSB
      else
        Y0 = 1'b0;  // Next state 100 LSB
    end
    default: begin
      Y0 = 1'b0;
      z = 1'b0;
    end
  endcase
end

endmodule