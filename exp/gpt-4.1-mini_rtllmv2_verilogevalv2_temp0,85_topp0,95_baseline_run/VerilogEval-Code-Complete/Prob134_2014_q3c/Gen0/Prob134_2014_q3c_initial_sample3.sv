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
      Y0 = (x == 0) ? 1'b0 : 1'b1; // next state: 000 -> Y0=0, 001 -> Y0=1
    end
    3'b001: begin
      z = 1'b0;
      Y0 = (x == 0) ? 1'b1 : 1'b0; // next state: 001 -> 001 (Y0=1), 100 (Y0=0)
    end
    3'b010: begin
      z = 1'b0;
      Y0 = (x == 0) ? 1'b0 : 1'b1; // next state: 010->010(Y0=0), 001(Y0=1)
    end
    3'b011: begin
      z = 1'b1;
      Y0 = (x == 0) ? 1'b1 : 1'b0; // next state: 011->001(Y0=1), 010(Y0=0)
    end
    3'b100: begin
      z = 1'b1;
      Y0 = (x == 0) ? 1'b1 : 1'b0; // next state: 100->011(Y0=1), 100(Y0=0)
    end
    default: begin
      z = 1'b0;
      Y0 = 1'b0;
    end
  endcase
end

endmodule