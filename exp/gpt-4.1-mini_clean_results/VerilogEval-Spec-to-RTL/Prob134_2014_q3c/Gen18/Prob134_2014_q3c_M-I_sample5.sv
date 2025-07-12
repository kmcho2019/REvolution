module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode key states with bitwise operations
    wire is_100 = y[2] & ~y[1] & ~y[0];
    wire is_011 = ~y[2] & y[1] & y[0];
    wire is_010 = ~y[2] & y[1] & ~y[0];
    wire is_001 = ~y[2] & ~y[1] & y[0];

    // next_state[2]: x & (y==001 or y==100)
    wire ns2 = x & (is_001 | is_100);

    // next_state[1]:
    // ns1 = (~x & (is_010 | is_100)) | (x & is_011)
    wire ns1 = (~x & (is_010 | is_100)) | (x & is_011);

    // next_state[0]:
    // ns0 = x if y in {000,010}, else ~x
    wire y_in_000_or_010 = (~y[2]) & (~y[0]);
    wire ns0 = y_in_000_or_010 ? x : ~x;

    wire [2:0] next_state = {ns2, ns1, ns0};

    // output z = (y==011 or y==100)
    wire z_int = is_100 | is_011;

    assign Y0 = next_state[0];
    assign z  = z_int;

endmodule