module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode states 001 and 100 with bitwise expressions instead of full equality
    wire is_001 = (~y[2]) & (~y[1]) & (y[0]);
    wire is_100 = (y[2]) & (~y[1]) & (~y[0]);

    // next_state[2] = x & (y==001 or y==100)
    wire ns2 = x & (is_001 | is_100);

    // next_state[1]:
    // true if (y==010 & x==0) or (y==011 & x==1) or (y==100 & x==0)
    // decode states 010 and 011 by bit checks:
    wire is_010 = (~y[2]) & (y[1]) & (~y[0]);
    wire is_011 = (~y[2]) & (y[1]) & (y[0]);
    wire ns1 = (is_010 & (~x)) | (is_011 & x) | (is_100 & (~x));

    // next_state[0]:
    // ns0 = x if y in {000,010}, else ~x
    // y in {000,010} means y[2]==0 && y[0]==0 (since 000=000, 010=010)
    // check y[2]==0 and y[0]==0 to detect these states
    wire y_in_000_or_010 = (~y[2]) & (~y[0]);
    wire ns0 = y_in_000_or_010 ? x : ~x;

    wire [2:0] next_state = {ns2, ns1, ns0};

    // output z = (y==011 or y==100)
    // Already minimal boolean expression:
    wire z_int = is_100 | is_011;

    assign z = z_int;
    assign Y0 = next_state[0];

endmodule