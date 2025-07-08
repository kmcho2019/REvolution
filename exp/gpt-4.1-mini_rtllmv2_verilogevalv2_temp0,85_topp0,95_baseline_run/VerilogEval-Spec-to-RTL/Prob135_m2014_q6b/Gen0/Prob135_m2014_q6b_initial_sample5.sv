module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1,
    output [2:0] y_next
);

    // Next state logic only for y[1]
    // y[1]_next depends on current y and w as per state transitions

    // Extract current state bits for clarity
    wire y0 = y[0];
    wire y1 = y[1];
    wire y2 = y[2];

    // We'll derive y[1]_next for each state and input w.
    // States: A=000, B=001, C=010, D=011, E=100, F=101
    // From the diagram:
    // A(000): w=0 -> B(001) => y[1] = 0; w=1 -> A(000) => y[1]=0
    // B(001): w=0 -> C(010) => y[1]=1; w=1 -> D(011) => y[1]=1
    // C(010): w=0 -> E(100) => y[1]=0; w=1 -> D(011) => y[1]=1
    // D(011): w=0 -> F(101) => y[1]=0; w=1 -> A(000) => y[1]=0
    // E(100): w=0 -> E(100) => y[1]=0; w=1 -> D(011) => y[1]=1
    // F(101): w=0 -> C(010) => y[1]=1; w=1 -> D(011) => y[1]=1

    // Define a function for next y1
    wire y1_next = 
        (~y2 & ~y1 &  y0 & ~w) ? 1'b1 :  // B(001), w=0 -> C(010), y[1]=1
        (~y2 & ~y1 &  y0 &  w) ? 1'b1 :  // B(001), w=1 -> D(011), y[1]=1
        (~y2 &  y1 & ~y0 &  w) ? 1'b1 :  // C(010), w=1 -> D(011), y[1]=1
        ( y2 & ~y1 & ~y0 &  w) ? 1'b1 :  // E(100), w=1 -> D(011), y[1]=1
        ( y2 & ~y1 &  y0 & ~w) ? 1'b1 :  // F(101), w=0 -> C(010), y[1]=1
        ( y2 & ~y1 &  y0 &  w) ? 1'b1 :  // F(101), w=1 -> D(011), y[1]=1
        1'b0;

    // For completeness, define y_next as current y, since only y[1] next is defined
    // The problem states only to implement next-state logic for y[1], so leave y[0] and y[2] unchanged here
    assign y_next = {y2, y1_next, y0};

    // Output Y1 = y[1]
    assign Y1 = y[1];

endmodule