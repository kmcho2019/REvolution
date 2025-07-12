module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Present state bits for easier reference
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Derive next state bits from FSM table by minimizing logic:

    // From FSM table:
    // ns2 = 1 when (y=001 and x=1) or (y=100 and x=1)
    // y=001 means y2=0,y1=0,y0=1; y=100 means y2=1,y1=0,y0=0
    // ns2 = x & ((~y2 & ~y1 & y0) | (y2 & ~y1 & ~y0))
    wire ns2 = x & ((~y2 & ~y1 & y0) | (y2 & ~y1 & ~y0));

    // ns1 = 1 when (y=010 & x=0) or (y=011 & x=1) or (y=100 & x=0)
    // y=010: y2=0,y1=1,y0=0; y=011: y2=0,y1=1,y0=1; y=100: y2=1,y1=0,y0=0
    wire ns1 =
        ((~y2 & y1 & ~y0) & ~x) |  // y=010,x=0
        ((~y2 & y1 & y0) &  x) |  // y=011,x=1
        ((y2  & ~y1 & ~y0) & ~x);  // y=100,x=0

    // ns0 logic: from table next state outputs ns0 is:
    // For y=000 or y=010: ns0 = x
    // Else ns0 = ~x
    // So ns0 = x if ((y==000) or (y==010)) else ~x

    // y=000: ~y2 & ~y1 & ~y0
    // y=010: ~y2 & y1 & ~y0
    wire y_eq_000_or_010 = (~y2 & ~y1 & ~y0) | (~y2 & y1 & ~y0);
    wire ns0 = y_eq_000_or_010 ? x : ~x;

    // Compose next state vector
    wire [2:0] next_state = {ns2, ns1, ns0};

    // Output z = 1 when y=011 or y=100
    // y=011: ~y2 & y1 & y0
    // y=100: y2 & ~y1 & ~y0
    wire z_int = ((~y2 & y1 & y0) | (y2 & ~y1 & ~y0));

    assign z  = z_int;
    assign Y0 = next_state[0];

endmodule