module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @(*) begin
  // Default assignments
  Y0 = 0;
  z = 0;
  
  case (y)
    3'b000: begin
      z = 0;
      Y0 = (x == 1'b0) ? 1'b0 : 1'b1;  // Next states 000 or 001
    end
    3'b001: begin
      z = 0;
      Y0 = (x == 1'b0) ? 1'b1 : 1'b0;  // Next states 001 or 100
    end
    3'b010: begin
      z = 0;
      Y0 = (x == 1'b0) ? 1'b0 : 1'b1;  // Next states 010 or 001
    end
    3'b011: begin
      z = 1;
      Y0 = (x == 1'b0) ? 1'b1 : 1'b0;  // Next states 001 or 010
    end
    3'b100: begin
      z = 1;
      Y0 = (x == 1'b0) ? 1'b1 : 1'b0;  // Next states 011 or 100
    end
    default: begin
      z = 0;
      Y0 = 0;
    end
  endcase
end

endmodule