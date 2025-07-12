module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode key present states for clarity and reuse
    wire is_000 = (~y[2]) & (~y[1]) & (~y[0]);
    wire is_001 = (~y[2]) & (~y[1]) & ( y[0]);
    wire is_010 = (~y[2]) & ( y[1]) & (~y[0]);
    wire is_011 = (~y[2]) & ( y[1]) & ( y[0]);
    wire is_100 = ( y[2]) & (~y[1]) & (~y[0]);

    // Next state bit 2:
    // From FSM table: ns2 = x & (y==001 or y==100)
    wire ns2 = x & (is_001 | is_100);

    // Next state bit 1:
    // ns1 = (~x & (y==010 or y==100)) | (x & y==011)
    wire ns1 = (~x & (is_010 | is_100)) | (x & is_011);

    // Next state bit 0:
    // ns0 = x if y in {000,010}, else ~x
    // Condition: y_in_000_or_010 = ~y[2] & ~y[0]
    wire y_in_000_or_010 = (~y[2]) & (~y[0]);
    wire ns0 = y_in_000_or_010 ? x : ~x;

    // Output z = 1 if present state is 011 or 100
    wire z_int = is_011 | is_100;

    // Assign output Y0 as next_state[0]
    assign Y0 = ns0;
    assign z  = z_int;

endmodule