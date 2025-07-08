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
        if (x == 0)
          Y0 = 0; // Next state 000 -> Y0=0
        else
          Y0 = 1; // Next state 001 -> Y0=1
      end
      3'b001: begin
        z = 0;
        if (x == 0)
          Y0 = 1; // Next state 001 -> Y0=1
        else
          Y0 = 0; // Next state 100 -> Y0=0
      end
      3'b010: begin
        z = 0;
        if (x == 0)
          Y0 = 0; // Next state 010 -> Y0=0
        else
          Y0 = 1; // Next state 001 -> Y0=1
      end
      3'b011: begin
        z = 1;
        if (x == 0)
          Y0 = 1; // Next state 001 -> Y0=1
        else
          Y0 = 0; // Next state 010 -> Y0=0
      end
      3'b100: begin
        z = 1;
        if (x == 0)
          Y0 = 1; // Next state 011 -> Y0=1
        else
          Y0 = 0; // Next state 100 -> Y0=0
      end
      default: begin
        z = 0;
        Y0 = 0;
      end
    endcase
  end

endmodule