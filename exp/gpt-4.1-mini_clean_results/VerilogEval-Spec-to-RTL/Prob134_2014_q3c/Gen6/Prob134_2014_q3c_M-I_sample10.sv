module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Present state y is 3 bits: y[2], y[1], y[0]
    // Next state Y[2], Y[1], Y[0] are expressed as combinational logic of y and x

    // Derive next state bits from table:

    // From given table:
    // State 000 (y=000): x=0 -> 000; x=1 -> 001
    // State 001 (001): x=0 -> 001; x=1 -> 100
    // State 010 (010): x=0 -> 010; x=1 -> 001
    // State 011 (011): x=0 -> 001; x=1 -> 010
    // State 100 (100): x=0 -> 011; x=1 -> 100

    // Let's write next state bits explicitly for all 5 states:

    // next_state[2] logic (MSB)
    // y=000: x=0->0, x=1->0
    // y=001: x=0->0, x=1->1
    // y=010: x=0->0, x=1->0
    // y=011: x=0->0, x=1->0
    // y=100: x=0->0, x=1->1
    //
    // So next_state[2] = 1 only when (y=001 and x=1) or (y=100 and x=1)
    // y=001 is y[2:0]=0_0_1
    // y=100 is 1_0_0
    //
    // next_state[2] = x & ((~y[2] & ~y[1] & y[0]) | (y[2] & ~y[1] & ~y[0]))

    wire y0 = y[0];
    wire y1 = y[1];
    wire y2 = y[2];

    wire nst2 = x & ((~y2 & ~y1 & y0) | (y2 & ~y1 & ~y0));

    // next_state[1] logic (middle bit)
    // Check table:

    // y=000: x=0->0, x=1->0
    // y=001: x=0->0, x=1->0
    // y=010: x=0->1, x=1->0
    // y=011: x=0->0, x=1->1
    // y=100: x=0->1, x=1->0

    // Let's note next_state[1] values:
    // y=010,x=0 => 1
    // y=011,x=1 => 1
    // y=100,x=0 => 1

    // So next_state[1] = 1 when:
    // (y=010 and x=0) or (y=011 and x=1) or (y=100 and x=0)

    // Express as logic:
    // (y2,y1,y0) = 0 1 0 -> next_state[1]=1 when x=0
    // (0 1 1) when x=1
    // (1 0 0) when x=0

    // next_state[1] = (~x & ((~y2 & y1 & ~y0) | (y2 & ~y1 & ~y0))) | (x & (~y2 & y1 & y0))

    wire nst1 = (~x & ((~y2 & y1 & ~y0) | (y2 & ~y1 & ~y0))) | (x & (~y2 & y1 & y0));

    // next_state[0] logic (LSB)
    // Check table:

    // y=000: x=0->0, x=1->1
    // y=001: x=0->1, x=1->0
    // y=010: x=0->0, x=1->1
    // y=011: x=0->1, x=1->0
    // y=100: x=0->1, x=1->0

    // Note where next_state[0]=1:
    // (y=000,x=1), (y=001,x=0), (y=010,x=1), (y=011,x=0), (y=100,x=0)

    // Express next_state[0]:
    // next_state[0] = (x & ~y2 & ~y1 & ~y0) 
    //               | (~x & ~y2 & ~y1 & y0)
    //               | (x & ~y2 & y1 & ~y0)
    //               | (~x & ~y2 & y1 & y0)
    //               | (~x & y2 & ~y1 & ~y0)

    // Simplify by using sum of minterms directly:

    wire nst0 = (x & ~y2 & ~y1 & ~y0) 
              | (~x & ~y2 & ~y1 & y0)
              | (x & ~y2 & y1 & ~y0)
              | (~x & ~y2 & y1 & y0)
              | (~x & y2 & ~y1 & ~y0);

    // z output is high when present state y=011 or y=100

    assign z = (y == 3'b011) || (y == 3'b100);

    assign Y0 = nst0;

endmodule