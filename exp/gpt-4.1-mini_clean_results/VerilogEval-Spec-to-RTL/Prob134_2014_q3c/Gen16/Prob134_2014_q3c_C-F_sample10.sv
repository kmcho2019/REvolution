module TopModule (
    input        clk,    // Unused clock input
    input        x,
    input  [2:0] y,      // Present state
    output       Y0,
    output       z
);

    // Optimized combinational logic for next state bits derived from FSM table
    // Next state bit 2 (ns2): 1 iff (y=001 & x=1) or (y=100 & x=1)
    // Decode minimal conditions without full comparators:
    wire y_is_001 = (~y[2]) & (~y[1]) & y[0];
    wire y_is_100 = y[2] & (~y[1]) & (~y[0]);
    wire ns2 = (y_is_001 & x) | (y_is_100 & x);

    // Next state bit 1 (ns1): 1 iff
    // (y=010 & x=0) or (y=011 & x=1) or (y=100 & x=0)
    wire y_is_010 = (~y[2]) & y[1] & (~y[0]);
    wire y_is_011 = (~y[2]) & y[1] & y[0];
    wire ns1 = (y_is_010 & ~x) | (y_is_011 & x) | (y_is_100 & ~x);

    // Next state bit 0 (ns0):
    // For y in {000, 010} next_state[0] = x
    // Else next_state[0] = ~x
    // Detect y in 000 or 010:
    wire y_is_000 = (~y[2]) & (~y[1]) & (~y[0]);
    wire ns0 = ((y_is_000 | y_is_010) ? x : ~x);

    // Output z = 1 if present state y is 011 or 100
    wire z_int = ((~y[2]) & y[1] & y[0]) | (y[2] & (~y[1]) & (~y[0]));

    assign Y0 = ns0;
    assign z = z_int;

endmodule