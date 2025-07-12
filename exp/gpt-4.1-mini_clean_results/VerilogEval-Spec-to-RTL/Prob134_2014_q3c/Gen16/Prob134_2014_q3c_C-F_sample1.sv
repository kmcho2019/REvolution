module TopModule (
    input      x,
    input [2:0] y,
    output     Y0,
    output     z
);

    // Common subexpressions for state matches used multiple times
    wire y_is_001 = (~y[2]) & (~y[1]) & y[0];
    wire y_is_100 = y[2] & (~y[1]) & (~y[0]);
    wire y_is_011 = (~y[2]) & y[1] & y[0];
    wire y_is_000 = (~y[2]) & (~y[1]) & (~y[0]);
    wire y_is_010 = (~y[2]) & y[1] & (~y[0]);

    // next_state bit 2: (y==001 and x=1) or (y==100 and x=1)
    wire ns2 = x & (y_is_001 | y_is_100);

    // next_state bit 1:
    // (y==010 and x=0) or (y==011 and x=1) or (y==100 and x=0)
    wire ns1 = ((~x) & (y_is_010 | y_is_100)) | (x & y_is_011);

    // next_state bit 0:
    // If y in {000,010} then ns0=x else ns0=~x
    wire ns0 = ((y_is_000 | y_is_010) ? x : ~x);

    // output z = 1 if y == 011 or y == 100
    wire z_int = y_is_011 | y_is_100;

    assign Y0 = ns0;
    assign z  = z_int;

endmodule