module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Next state bits directly from present state y and input x
    // ns2 = x & (~y[2] & ~y[1] & y[0] | y[2] & ~y[1] & ~y[0]) = x & ((~y[2]&~y[1]&y[0]) | (y[2]&~y[1]&~y[0]))
    wire ns2 = x & ((~y[2] & ~y[1] & y[0]) | (y[2] & ~y[1] & ~y[0]));

    // ns1 = (~x & ((~y[2]& y[1] & ~y[0]) | (y[2]&~y[1]&~y[0]))) | (x & (~y[2] & y[1] & y[0]))
    wire ns1 = (~x & ((~y[2] & y[1] & ~y[0]) | (y[2] & ~y[1] & ~y[0]))) | (x & (~y[2] & y[1] & y[0]));

    // ns0 = ((~y[2]& ~y[1] & ~y[0]) | (~y[2]& y[1] & ~y[0])) ? x : ~x
    // Implement as xnor of cond and x
    wire cond = (~y[2] & ~y[1] & ~y[0]) | (~y[2] & y[1] & ~y[0]);
    wire ns0 = ~(cond ^ x);

    // Output z = 1 if y == 011 or y == 100
    wire z_int = (~y[2] & y[1] & y[0]) | (y[2] & ~y[1] & ~y[0]);

    assign Y0 = ns0;
    assign z  = z_int;

endmodule