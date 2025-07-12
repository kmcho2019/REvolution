module TopModule (
    input  [3:0] x,  // x = {x4, x3, x2, x1} from problem notation
    output      f
);

    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    // From the Karnaugh map and don't-care assignments, 
    // minimal SOP derived directly from x inputs:

    // Expression derived by manual Karnaugh simplification:
    // f = x3 & x4 
    //   | x3 & x2
    //   | x4 & ~x3 & ~x2
    //   | ~x4 & x3 & ~x2 & x1;

    // Simplify step by step:
    // Group 1: x3 & x4
    // Group 2: x3 & x2
    // Group 3: x4 & ~x3 & ~x2
    // Group 4: ~x4 & x3 & ~x2 & x1

    assign f = (x3 & x4)
             | (x3 & x2)
             | (x4 & ~x3 & ~x2)
             | (~x4 & x3 & ~x2 & x1);

endmodule