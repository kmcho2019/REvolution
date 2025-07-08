module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);
  // States encoding:
  // A=000, B=001, C=010, D=011, E=100, F=101
  // y[3] = y[3], y[2] = y[2], y[1] = y[1]
  
  // Next state logic for y[2] (Y2):
  // From the state transitions, list out next states and their y[2]:
  // A(000)
  //   w=0 -> B(001), y2=0
  //   w=1 -> A(000), y2=0
  // B(001)
  //   w=0 -> C(010), y2=1
  //   w=1 -> D(011), y2=1
  // C(010)
  //   w=0 -> E(100), y2=0
  //   w=1 -> D(011), y2=1
  // D(011)
  //   w=0 -> F(101), y2=0
  //   w=1 -> A(000), y2=0
  // E(100)
  //   w=0 -> E(100), y2=0
  //   w=1 -> D(011), y2=1
  // F(101)
  //   w=0 -> C(010), y2=1
  //   w=1 -> D(011), y2=1
  
  always @(*) begin
    case (y)
      3'b000: Y2 = 1'b0;  // A
      3'b001: Y2 = 1'b1;  // B
      3'b010: Y2 = w ? 1'b1 : 1'b0; // C
      3'b011: Y2 = 1'b0;  // D
      3'b100: Y2 = w ? 1'b1 : 1'b0; // E
      3'b101: Y2 = 1'b1;  // F
      default: Y2 = 1'b0;
    endcase
  end
endmodule