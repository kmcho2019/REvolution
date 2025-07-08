module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @(*) begin
  // Default assignments
  Y0 = 1'b0;
  z = 1'b0;

  case (y)
    3'b000: begin
      z = 1'b0;
      if (x == 1'b0)
        Y0 = 1'b0; // next state 000
      else
        Y0 = 1'b1; // next state 001
    end
    3'b001: begin
      z = 1'b0;
      if (x == 1'b0)
        Y0 = 1'b1; // next state 001
      else
        Y0 = 1'b0; // next state 100 (100 LSB=0)
    end
    3'b010: begin
      z = 1'b0;
      if (x == 1'b0)
        Y0 = 1'b0; // next state 010
      else
        Y0 = 1'b1; // next state 001
    end
    3'b011: begin
      z = 1'b1;
      if (x == 1'b0)
        Y0 = 1'b1; // next state 001
      else
        Y0 = 1'b0; // next state 010
    end
    3'b100: begin
      z = 1'b1;
      if (x == 1'b0)
        Y0 = 1'b1; // next state 011
      else
        Y0 = 1'b0; // next state 100
    end
    default: begin
      z = 1'b0;
      Y0 = 1'b0;
    end
  endcase
end

endmodule