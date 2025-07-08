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
      z = 0;
      Y0 = (x == 1'b0) ? 1'b0 : 1'b1; // next states: 000(LSB=0), 001(LSB=1)
    end
    3'b001: begin
      z = 0;
      Y0 = (x == 1'b0) ? 1'b1 : 1'b0; // next states: 001(LSB=1), 100(LSB=0)
    end
    3'b010: begin
      z = 0;
      Y0 = (x == 1'b0) ? 1'b0 : 1'b1; // next states: 010(LSB=0), 001(LSB=1)
    end
    3'b011: begin
      z = 1;
      Y0 = (x == 1'b0) ? 1'b1 : 1'b0; // next states: 001(LSB=1), 010(LSB=0)
    end
    3'b100: begin
      z = 1;
      Y0 = (x == 1'b0) ? 1'b1 : 1'b0; // next states: 011(LSB=1), 100(LSB=0)
    end
    default: begin
      z = 1'b0;
      Y0 = 1'b0;
    end
  endcase
end

endmodule