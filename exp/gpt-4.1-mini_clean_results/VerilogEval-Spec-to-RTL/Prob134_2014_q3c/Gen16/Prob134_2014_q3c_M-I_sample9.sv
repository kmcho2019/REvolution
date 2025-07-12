module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Define states as wires for clarity and reuse
    wire state_000 = (~y[2]) & (~y[1]) & (~y[0]);
    wire state_001 = (~y[2]) & (~y[1]) & ( y[0]);
    wire state_010 = (~y[2]) & ( y[1]) & (~y[0]);
    wire state_011 = (~y[2]) & ( y[1]) & ( y[0]);
    wire state_100 = ( y[2]) & (~y[1]) & (~y[0]);

    // next_state[2] logic: ns2 = x & (state_001 | state_100)
    wire ns2 = x & (state_001 | state_100);

    // next_state[1] logic: ns1 = (~x & (state_010 | state_100)) | (x & state_011)
    wire ns1 = (~x & (state_010 | state_100)) | (x & state_011);

    // next_state[0] logic without conditional:
    // From table:
    // For states 000 and 010, ns0 = x
    // For others, ns0 = ~x
    // So ns0 = x when (state_000 | state_010)
    // else ns0 = ~x
    // Boolean: ns0 = (state_000 | state_010) ? x : ~x
    // Implement without ?: ns0 = (~(state_000 | state_010) & ~x) | ((state_000 | state_010) & x)
    wire cond = state_000 | state_010;
    wire ns0 = (cond & x) | (~cond & ~x);

    // output z = 1 if y=011 or y=100
    wire z_int = state_011 | state_100;

    assign Y0 = ns0;
    assign z = z_int;

endmodule