module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode present state y into signals without full equality comparators
    wire s000 = (~y[2]) & (~y[1]) & (~y[0]);
    wire s001 = (~y[2]) & (~y[1]) & ( y[0]);
    wire s010 = (~y[2]) & ( y[1]) & (~y[0]);
    wire s011 = (~y[2]) & ( y[1]) & ( y[0]);
    wire s100 = ( y[2]) & (~y[1]) & (~y[0]);

    // Shared sub-expressions for next_state[2] and output z:
    wire cond1 = s001 | s100;

    // next state bit 2:
    // ns2 = x & (y==001 or y==100)
    wire ns2 = x & cond1;

    // next state bit 1:
    // ns1=1 when:
    // (y=010 & x=0) or (y=011 & x=1) or (y=100 & x=0)
    wire ns1 = (s010 & ~x) | (s011 & x) | (s100 & ~x);

    // next state bit 0:
    // ns0 = x if y in {000,010} else ~x
    // avoid conditional operator by Boolean expression:
    // ns0 = ( (s000 | s010) & x ) | ( ~(s000 | s010) & ~x )
    wire s00_or_010 = s000 | s010;
    wire ns0 = (s00_or_010 & x) | (~s00_or_010 & ~x);

    // output z = 1 if y=011 or y=100
    wire z_int = s011 | s100;

    assign Y0 = ns0;
    assign z  = z_int;

endmodule