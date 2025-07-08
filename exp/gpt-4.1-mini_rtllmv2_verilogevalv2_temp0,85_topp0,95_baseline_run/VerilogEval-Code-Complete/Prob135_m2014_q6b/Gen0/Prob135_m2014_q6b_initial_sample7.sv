module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

  always @(*) begin
    // y[3], y[2], y[1] represent current state bits
    // Decode current state for clarity
    // States: A=000, B=001, C=010, D=011, E=100, F=101

    // From the state transitions, determine when next y[2] = 1:

    // Next state y2 next = 1 for states C(010), D(011), E(100), F(101)
    // So we identify transitions that go to those states.

    // Using the transition table and input w:
    // For each state and input, find next state and if y2(next) = 1

    // Transitions with y2(next)=1 (states C=010, D=011, E=100, F=101):
    // From A(000):
    //   w=0 -> B(001) y2=0
    //   w=1 -> A(000) y2=0
    // From B(001):
    //   w=0 -> C(010) y2=1
    //   w=1 -> D(011) y2=1
    // From C(010):
    //   w=0 -> E(100) y2=1
    //   w=1 -> D(011) y2=1
    // From D(011):
    //   w=0 -> F(101) y2=1
    //   w=1 -> A(000) y2=0
    // From E(100):
    //   w=0 -> E(100) y2=1
    //   w=1 -> D(011) y2=1
    // From F(101):
    //   w=0 -> C(010) y2=1
    //   w=1 -> D(011) y2=1

    // Express next y2 (Y2) as sum of conditions where next state y2=1:
    // Y2 = (B & ~w) + (B & w) + (C & ~w) + (C & w) + (D & ~w) + (E & ~w) + (E & w) + (F & ~w) + (F & w)
    // We can rewrite:
    // B current state: y=001 => y3=0 y2=0 y1=1
    // C current state: 010 => y3=0 y2=1 y1=0
    // D current state: 011 => y3=0 y2=1 y1=1
    // E current state: 100 => y3=1 y2=0 y1=0
    // F current state: 101 => y3=1 y2=0 y1=1

    // Let's write each term explicitly:

    // B & ~w => (y3=0 & y2=0 & y1=1) & ~w
    // B & w  => (y3=0 & y2=0 & y1=1) & w

    // Thus B contributes whenever y3=0,y2=0,y1=1 (state B), regardless of w.

    // Similarly:
    // C & ~w => (0 1 0) & ~w
    // C & w  => (0 1 0) & w
    // C contributes regardless of w.

    // D & ~w => (0 1 1) & ~w
    // D & w  => (0 1 1) & w, but note w=1 causes next state A(0), which has y2=0
    // From above, for D state and w=1, next y2=0, so only D & ~w contributes.

    // E & ~w => (1 0 0) & ~w
    // E & w  => (1 0 0) & w

    // F & ~w => (1 0 1) & ~w
    // F & w  => (1 0 1) & w

    // So the sum is:
    // Y2 = B + C + (D & ~w) + E + F

    // States B,C,E,F all cause Y2=1 regardless of w, only D depends on w.

    // Define each state signal:
    wire B = (~y[3]) & (~y[2]) & ( y[1]);
    wire C = (~y[3]) & ( y[2]) & (~y[1]);
    wire D = (~y[3]) & ( y[2]) & ( y[1]);
    wire E = ( y[3]) & (~y[2]) & (~y[1]);
    wire F = ( y[3]) & (~y[2]) & ( y[1]);

    Y2 = B | C | (D & (~w)) | E | F;
  end

endmodule