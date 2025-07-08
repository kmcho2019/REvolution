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
        // next state when x=0: 000 -> Y0=0
        // next state when x=1: 001 -> Y0=1
        Y0 = (x == 1'b0) ? 1'b0 : 1'b1;
        z = 1'b0;
      end
      3'b001: begin
        // next state when x=0: 001 -> Y0=1
        // next state when x=1: 100 -> Y0=0
        Y0 = (x == 1'b0) ? 1'b1 : 1'b0;
        z = 1'b0;
      end
      3'b010: begin
        // next state when x=0: 010 -> Y0=0
        // next state when x=1: 001 -> Y0=1
        Y0 = (x == 1'b0) ? 1'b0 : 1'b1;
        z = 1'b0;
      end
      3'b011: begin
        // next state when x=0: 001 -> Y0=1
        // next state when x=1: 010 -> Y0=0
        Y0 = (x == 1'b0) ? 1'b1 : 1'b0;
        z = 1'b1;
      end
      3'b100: begin
        // next state when x=0: 011 -> Y0=1
        // next state when x=1: 100 -> Y0=0
        Y0 = (x == 1'b0) ? 1'b1 : 1'b0;
        z = 1'b1;
      end
      default: begin
        Y0 = 1'b0;
        z = 1'b0;
      end
    endcase
  end

endmodule