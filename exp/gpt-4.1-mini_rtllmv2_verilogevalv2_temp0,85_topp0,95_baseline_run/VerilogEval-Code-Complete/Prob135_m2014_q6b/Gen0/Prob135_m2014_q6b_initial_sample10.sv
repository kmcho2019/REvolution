module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

  always @(*) begin
    case ({y,w})
      // State A=000
      4'b0000: Y2 = 0; // A(0) -> B=001 y2=0
      4'b0001: Y2 = 0; // A(1) -> A=000 y2=0

      // State B=001
      4'b0010: Y2 = 1; // B(0) -> C=010 y2=1
      4'b0011: Y2 = 1; // B(1) -> D=011 y2=1

      // State C=010
      4'b0100: Y2 = 0; // C(0) -> E=100 y2=0
      4'b0101: Y2 = 1; // C(1) -> D=011 y2=1

      // State D=011
      4'b0110: Y2 = 1; // D(0) -> F=101 y2=0 (check!)
      4'b0111: Y2 = 0; // D(1) -> A=000 y2=0

      // State E=100
      4'b1000: Y2 = 0; // E(0) -> E=100 y2=0
      4'b1001: Y2 = 1; // E(1) -> D=011 y2=1

      // State F=101
      4'b1010: Y2 = 0; // F(0) -> C=010 y2=1 (check!)
      4'b1011: Y2 = 1; // F(1) -> D=011 y2=1

      default: Y2 = 0;
    endcase
  end

endmodule