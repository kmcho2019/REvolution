module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // From the FSM table, derive next state bits and output directly:

    // next_state[2] = (y==001 and x==1) or (y==100 and x==1)
    // y==001: y=3'b001 => y[2]=0, y[1]=0, y[0]=1
    // y==100: y=3'b100 => y[2]=1, y[1]=0, y[0]=0
    // So ns2 = x & ((~y[2]&~y[1]&y[0]) | (y[2]&~y[1]&~y[0]))
    wire ns2 = x & (((~y[2]) & (~y[1]) & y[0]) | (y[2] & (~y[1]) & (~y[0])));

    // next_state[1] = (y==010 & ~x) or (y==011 & x) or (y==100 & ~x)
    // y==010: y=010, y[2]=0,y[1]=1,y[0]=0
    // y==011: y=011, y[2]=0,y[1]=1,y[0]=1
    // y==100: y=100, y[2]=1,y[1]=0,y[0]=0
    wire ns1 = ((~x) & ((~y[2]) & y[1] & (~y[0]) | (y[2] & (~y[1]) & (~y[0]))))
               | (x & (~y[2]) & y[1] & y[0]);

    // next_state[0] = x if y in {000,010} else ~x
    // y==000: y=000
    // y==010: y=010
    // So condition: (~y[2]&~y[1]&~y[0]) | (~y[2]&y[1]&~y[0])
    wire cond = (~y[2]&~y[1]&~y[0]) | (~y[2]&y[1]&~y[0]);
    wire ns0 = cond ? x : ~x;

    // output z = 1 if y=011 or y=100
    // y=011: 0 1 1; y=100:1 0 0
    wire z_int = ((~y[2]) & y[1] & y[0]) | (y[2] & (~y[1]) & (~y[0]));

    assign Y0 = ns0;
    assign z = z_int;

endmodule