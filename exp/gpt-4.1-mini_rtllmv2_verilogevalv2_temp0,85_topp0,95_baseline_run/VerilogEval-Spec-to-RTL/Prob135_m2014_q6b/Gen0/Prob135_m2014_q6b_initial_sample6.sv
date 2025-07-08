module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Next state logic for y[1] only, based on the state transitions and input w
    // States: A=000, B=001, C=010, D=011, E=100, F=101
    // Using the transition table and current y and w, derive next y[1]

    wire next_y1;

    /*
    State transitions (y[2:0]) and next states:

    From A(000):
      w=0 -> B(001) y[1]=0
      w=1 -> A(000) y[1]=0

    From B(001):
      w=0 -> C(010) y[1]=1
      w=1 -> D(011) y[1]=1

    From C(010):
      w=0 -> E(100) y[1]=0
      w=1 -> D(011) y[1]=1

    From D(011):
      w=0 -> F(101) y[1]=0
      w=1 -> A(000) y[1]=0

    From E(100):
      w=0 -> E(100) y[1]=0
      w=1 -> D(011) y[1]=1

    From F(101):
      w=0 -> C(010) y[1]=1
      w=1 -> D(011) y[1]=1

    We can write logic for next_y1 = f(y, w):

    next_y1 = 
      ( (y==3'b001) ) ? 1 : // B: next y[1] =1 for both w=0,1
      ( (y==3'b010) & w ) ? 1 : // C: w=1 -> y[1]=1
      ( (y==3'b100) & w ) ? 1 : // E: w=1 -> y[1]=1
      ( (y==3'b101) ) ? 1 : // F: both w=0,1 -> y[1]=1
      0; // else 0

    Simplify with boolean expressions.

    */

    wire y_eq_A = (y == 3'b000);
    wire y_eq_B = (y == 3'b001);
    wire y_eq_C = (y == 3'b010);
    wire y_eq_D = (y == 3'b011);
    wire y_eq_E = (y == 3'b100);
    wire y_eq_F = (y == 3'b101);

    assign next_y1 = ( y_eq_B ) ? 1'b1 :
                     ( y_eq_C & w ) ? 1'b1 :
                     ( y_eq_E & w ) ? 1'b1 :
                     ( y_eq_F ) ? 1'b1 :
                     1'b0;

    assign Y1 = y[1];

endmodule