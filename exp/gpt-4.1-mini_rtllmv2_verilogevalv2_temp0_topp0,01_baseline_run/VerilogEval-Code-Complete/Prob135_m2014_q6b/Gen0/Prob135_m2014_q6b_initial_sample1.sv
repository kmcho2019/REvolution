module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

  // State encoding:
  // A = 3'b000
  // B = 3'b001
  // C = 3'b010
  // D = 3'b011
  // E = 3'b100
  // F = 3'b101

  // Next state transitions (from problem):
  // A(000): w=0 -> B(001), w=1 -> A(000)
  // B(001): w=0 -> C(010), w=1 -> D(011)
  // C(010): w=0 -> E(100), w=1 -> D(011)
  // D(011): w=0 -> F(101), w=1 -> A(000)
  // E(100): w=0 -> E(100), w=1 -> D(011)
  // F(101): w=0 -> C(010), w=1 -> D(011)

  always @(*) begin
    case ({y, w})
      // A=000
      4'b0000: Y2 = 1'b0; // next B=001 (y2=0)
      4'b0001: Y2 = 1'b0; // next A=000 (y2=0)

      // B=001
      4'b0010: Y2 = 1'b1; // next C=010 (y2=1)
      4'b0011: Y2 = 1'b1; // next D=011 (y2=1)

      // C=010
      4'b0100: Y2 = 1'b0; // next E=100 (y2=0)
      4'b0101: Y2 = 1'b1; // next D=011 (y2=1)

      // D=011
      4'b0110: Y2 = 1'b1; // next F=101 (y2=1)
      4'b0111: Y2 = 1'b0; // next A=000 (y2=0)

      // E=100
      4'b1000: Y2 = 1'b0; // next E=100 (y2=0)
      4'b1001: Y2 = 1'b1; // next D=011 (y2=1)

      // F=101
      4'b1010: Y2 = 1'b1; // next C=010 (y2=1)
      4'b1011: Y2 = 1'b1; // next D=011 (y2=1)

      default: Y2 = 1'b0; // default safe value
    endcase
  end

endmodule