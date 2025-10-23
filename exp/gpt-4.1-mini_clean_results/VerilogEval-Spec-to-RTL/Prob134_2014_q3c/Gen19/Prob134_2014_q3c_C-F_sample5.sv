module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Shared decoded present states using bit-level expressions
    wire is_000 = (~y[2]) & (~y[1]) & (~y[0]);
    wire is_001 = (~y[2]) & (~y[1]) & ( y[0]);
    wire is_010 = (~y[2]) & ( y[1]) & (~y[0]);
    wire is_011 = (~y[2]) & ( y[1]) & ( y[0]);
    wire is_100 = ( y[2]) & (~y[1]) & (~y[0]);

    // Next state bit 2: ns2 = x & (y==001 or y==100)
    wire ns2 = x & (is_001 | is_100);

    // Next state bit 1:
    // ns1 = (y==010 & x==0) | (y==011 & x==1) | (y==100 & x==0)
    wire ns1 = (is_010 & ~x) | (is_011 & x) | (is_100 & ~x);

    // Next state bit 0:
    // ns0 = x if y in {000,010}, else ~x
    wire in_000_or_010 = is_000 | is_010;
    wire ns0 = in_000_or_010 ? x : ~x;

    wire [2:0] next_state = {ns2, ns1, ns0};

    // Output z = 1 if y==011 or y==100
    wire z_int = is_011 | is_100;

    assign Y0 = next_state[0];
    assign z = z_int;

endmodule