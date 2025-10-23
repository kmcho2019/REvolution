module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode all relevant states explicitly with bitwise ops (no equality comparators)
    wire s000 = ~y[2] & ~y[1] & ~y[0];
    wire s001 = ~y[2] & ~y[1] &  y[0];
    wire s010 = ~y[2] &  y[1] & ~y[0];
    wire s011 = ~y[2] &  y[1] &  y[0];
    wire s100 =  y[2] & ~y[1] & ~y[0];

    // next_state[2]: x & (s001 or s100)
    wire ns2 = x & (s001 | s100);

    // next_state[1]: (~x & (s010 | s100)) | (x & s011)
    wire ns1 = (~x & (s010 | s100)) | (x & s011);

    // next_state[0]: x if in s000 or s010 else ~x
    // Boolean mux form: ns0 = ( (s000 | s010) & x ) | ( ~(s000 | s010) & ~x )
    wire s000_or_010 = s000 | s010;
    wire ns0 = (s000_or_010 & x) | (~s000_or_010 & ~x);

    // output z: 1 when present state is s011 or s100
    wire z_int = s011 | s100;

    // Assign outputs
    assign Y0 = ns0;
    assign z  = z_int;

endmodule