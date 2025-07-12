module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Next state logic derived from the table
    // Present state y[2:0]: 000,001,010,011,100
    // Next state for x=0 and x=1 given

    // For clarity, assign y bits:
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next state bits (Y[2], Y[1], Y[0]) as functions of y and x
    // Using the table:

    // y=000 (0): x=0->000, x=1->001
    // y=001 (1): x=0->001, x=1->100
    // y=010 (2): x=0->010, x=1->001
    // y=011 (3): x=0->001, x=1->010
    // y=100 (4): x=0->011, x=1->100

    // Derive Y2:
    // Y2=1 when next state is 100 or 011 or 010 depending on inputs
    // Check each case:
    // y=001 x=1 -> 100 (Y2=1)
    // y=010 x=0 -> 010 (Y2=0)
    // y=011 x=1 -> 010 (Y2=0)
    // y=100 x=0 -> 011 (Y2=0)
    // Only y=001,x=1 gives Y2=1; also y=100,x=1 ->100 (Y2=1)
    // Actually y=100,x=1->100 (Y2=1)
    // So Y2=1 when (y=001 and x=1) or (y=100 and x=1)

    wire y_eq_001 = (~y2) & (~y1) & y0;
    wire y_eq_100 = y2 & (~y1) & (~y0);

    wire Y2 = (y_eq_001 & x) | (y_eq_100 & x);

    // Y1:
    // Next state Y1=1 when next state is 001(0x1), 011(0x3), or 010(0x2), or 100(0x4)
    // From table:
    // y=000 x=1 -> 001 (Y1=0)
    // y=001 x=0 -> 001 (Y1=0)
    // y=010 x=0 -> 010 (Y1=1)
    // y=011 x=1 -> 010 (Y1=1)
    // y=100 x=0 -> 011 (Y1=1)
    // So Y1=1 when (y=010 and x=0) or (y=011 and x=1) or (y=100 and x=0)

    wire y_eq_010 = (~y2) & y1 & (~y0);
    wire y_eq_011 = (~y2) & y1 & y0;

    wire Y1 = (y_eq_010 & ~x) | (y_eq_011 & x) | (y_eq_100 & ~x);

    // Y0:
    // Next state Y0=1 when next state is 001(1), 011(3), or 010(2)
    // From table:
    // y=000 x=1 -> 001 (Y0=1)
    // y=001 x=0 -> 001 (Y0=1)
    // y=010 x=1 -> 001 (Y0=1)
    // y=011 x=0 -> 001 (Y0=1)
    // y=100 x=0 -> 011 (Y0=1)
    // y=001 x=1 -> 100 (Y0=0)
    // y=100 x=1 -> 100 (Y0=0)

    // So Y0=1 when next state is 001 or 011 or 010, which corresponds to when next state LSB is 1

    // We can express Y0 in terms of y and x by checking above:

    // From next_state:
    // Next state LSB = 1 for:
    // y=000,x=1
    // y=001,x=0
    // y=010,x=1
    // y=011,x=0
    // y=100,x=0

    // So Y0 = (y=000 & x=1) | (y=001 & x=0) | (y=010 & x=1) | (y=011 & x=0) | (y=100 & x=0)

    wire y_eq_000 = (~y2) & (~y1) & (~y0);

    wire Y0 = (y_eq_000 & x) | (y_eq_001 & ~x) | (y_eq_010 & x) | (y_eq_011 & ~x) | (y_eq_100 & ~x);

    // Output z = 1 if present state y is 011 or 100
    wire z = y_eq_011 | y_eq_100;

    assign Y0 = Y0;
    assign z = z;

endmodule