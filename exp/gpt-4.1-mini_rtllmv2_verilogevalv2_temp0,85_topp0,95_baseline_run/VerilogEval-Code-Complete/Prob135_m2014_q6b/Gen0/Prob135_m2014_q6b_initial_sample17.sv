module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);
  // y: current state bits y[3], y[2], y[1]
  // State encoding: A=000, B=001, C=010, D=011, E=100, F=101
  // Next state y[2] bit logic from the state transitions:
  // Next states for each current state and input:
  // A(000): w=0->B(001) y[2]=0, w=1->A(000) y[2]=0
  // B(001): w=0->C(010) y[2]=1, w=1->D(011) y[2]=1
  // C(010): w=0->E(100) y[2]=0, w=1->D(011) y[2]=1
  // D(011): w=0->F(101) y[2]=0, w=1->A(000) y[2]=0
  // E(100): w=0->E(100) y[2]=0, w=1->D(011) y[2]=1
  // F(101): w=0->C(010) y[2]=1, w=1->D(011) y[2]=1

  always @(*) begin
    case({y, w})
      4'b0000: Y2 = 0; // A,0 -> B(001)
      4'b0001: Y2 = 0; // A,1 -> A(000)
      4'b0010: Y2 = 1; // B,0 -> C(010)
      4'b0011: Y2 = 1; // B,1 -> D(011)
      4'b0100: Y2 = 0; // C,0 -> E(100)
      4'b0101: Y2 = 1; // C,1 -> D(011)
      4'b0110: Y2 = 0; // D,0 -> F(101)
      4'b0111: Y2 = 0; // D,1 -> A(000)
      4'b1000: Y2 = 0; // E,0 -> E(100)
      4'b1001: Y2 = 1; // E,1 -> D(011)
      4'b1010: Y2 = 1; // F,0 -> C(010)
      4'b1011: Y2 = 1; // F,1 -> D(011)
      default: Y2 = 0; // default to 0
    endcase
  end
endmodule