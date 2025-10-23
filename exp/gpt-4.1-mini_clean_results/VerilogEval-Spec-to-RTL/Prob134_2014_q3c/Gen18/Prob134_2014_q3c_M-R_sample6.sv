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

    // Derive next state bits (ns2, ns1, ns0) from present state y and input x
    // According to the FSM table:
    // For ns2:
    // ns2 = 1 when (y == 001 && x == 1) or (y == 100 && x == 1)
    // That is: (y2'y1'y0 & x) or (y2 y1' y0' & x)
    wire ns2 = ((~y2 &  y1 & ~y0 & x) | (y2 & ~y1 & ~y0 & x));

    // For ns1:
    // ns1 = 1 when (y == 010 && x == 0) or (y == 011 && x == 1) or (y == 100 && x == 0)
    // (y2' y1 y0' & ~x) or (y2' y1 y0 & x) or (y2 y1' y0' & ~x)
    wire ns1 = ((~y2 &  y1 & ~y0 & ~x) | (~y2 & y1 & y0 & x) | (y2 & ~y1 & ~y0 & ~x));

    // For ns0:
    // ns0 is 0 except:
    // when y == 000 or y == 010, ns0 = x
    // else ns0 = ~x
    // ( (y == 000 or y == 010) ? x : ~x )
    // ( ( ~y2 & ~y1 & ~y0 ) or ( ~y2 & y1 & ~y0 )) ? x : ~x
    wire ns0 = (((~y2 & ~y1 & ~y0) | (~y2 & y1 & ~y0)) ? x : ~x);

    // Output z is high when present state y == 011 or y == 100
    // y == 011: ~y2 & y1 & y0
    // y == 100: y2 & ~y1 & ~y0
    wire z_int = ((~y2 & y1 & y0) | (y2 & ~y1 & ~y0));

    assign Y0 = ns0;
    assign z = z_int;

endmodule