module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Common state conditions
    wire S1 = (~y[2]) & (~y[1]) & y[0];   // y==001
    wire S2 = y[2] & (~y[1]) & (~y[0]);   // y==100
    wire S3 = (~y[2]) & y[1] & y[0];      // y==011
    wire S4 = (~y[2]) & (~y[1]) & (~y[0]); // y==000
    wire S5 = (~y[2]) & y[1] & (~y[0]);    // y==010

    // next_state bit 2
    wire ns2 = x & (S1 | S2);

    // next_state bit 1
    wire ns1 = ((~x) & ((S5) | (S2))) | (x & S3);

    // next_state bit 0 without conditional operator:
    // ns0 = if (y in {000,010}) then x else ~x
    // Condition: S4 | S5
    // ns0 = x & (S4 | S5) | (~x) & ~(S4 | S5)
    wire cond = S4 | S5;
    wire ns0 = (x & cond) | (~x & ~cond);

    // output z = 1 if y==011 or y==100
    wire z_int = S3 | S2;

    assign Y0 = ns0;
    assign z = z_int;

endmodule