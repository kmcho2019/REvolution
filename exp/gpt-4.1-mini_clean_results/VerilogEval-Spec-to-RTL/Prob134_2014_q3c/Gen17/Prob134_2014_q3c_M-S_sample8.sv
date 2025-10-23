module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Present state bits
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next state bits from FSM table:
    // ns2 = (y=001 & x=1) or (y=100 & x=1) => ns2 = (~y2 & y1 & ~y0 & x) | (y2 & ~y1 & ~y0 & x)
    wire ns2 = ((~y2 &  y1 & ~y0) | (y2 & ~y1 & ~y0)) & x;

    // ns1 = (y=010 & x=0) or (y=011 & x=1) or (y=100 & x=0)
    // ns1 = (~y2 & y1 & ~y0 & ~x) | (~y2 & y1 & y0 & x) | (y2 & ~y1 & ~y0 & ~x)
    wire ns1 = ((~y2 &  y1 & ~y0 & ~x) | (~y2 &  y1 &  y0 & x) | ( y2 & ~y1 & ~y0 & ~x));

    // ns0 = For y=000 or 010: ns0 = x, else ns0 = ~x
    // Implemented as: ns0 = (~y2 & ~y1 & ~y0 | ~y2 & y1 & ~y0) ? x : ~x
    // Equivalent: ns0 = ((~y2 & ~y1 & ~y0) | (~y2 & y1 & ~y0)) ? x : ~x
    // Simplify by Boolean expressions:
    // ns0 = ( (~y2 & ~y1 & ~y0) | (~y2 & y1 & ~y0) ) ? x : ~x
    // Using mux style: ns0 = ((~y2 & ~y0) & ((~y1) | y1)) ? x : ~x => ns0 = (~y2 & ~y0) ? x : ~x
    wire ns0 = (~y2 & ~y0) ? x : ~x;

    // Output z = 1 if y=011 or y=100
    // z = (~y2 & y1 & y0) | (y2 & ~y1 & ~y0)
    wire z_int = (~y2 & y1 & y0) | (y2 & ~y1 & ~y0);

    assign Y0 = ns0;
    assign z = z_int;

endmodule