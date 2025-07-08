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
        // Next states: 000 (x=0), 001 (x=1)
        Y0 = (x == 1'b0) ? 1'b0 : 1'b1; // next state LSB
        z  = 1'b0;
      end
      3'b001: begin
        // Next states: 001 (x=0), 100 (x=1)
        Y0 = (x == 1'b0) ? 1'b1 : 1'b0;
        z  = 1'b0;
      end
      3'b010: begin
        // Next states: 010 (x=0), 001 (x=1)
        Y0 = (x == 1'b0) ? 1'b0 : 1'b1;
        z  = 1'b0;
      end
      3'b011: begin
        // Next states: 001 (x=0), 010 (x=1)
        Y0 = (x == 1'b0) ? 1'b1 : 1'b0;
        z  = 1'b1;
      end
      3'b100: begin
        // Next states: 011 (x=0), 100 (x=1)
        Y0 = (x == 1'b0) ? 1'b1 : 1'b0;
        z  = 1'b1;
      end
      default: begin
        // Undefined states
        Y0 = 1'b0;
        z  = 1'b0;
      end
    endcase
  end
endmodule