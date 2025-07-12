module TopModule (
    input  x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode states with bitwise expressions
    wire is_001 = (~y[2]) & (~y[1]) & (y[0]);
    wire is_100 = (y[2]) & (~y[1]) & (~y[0]);
    wire is_010 = (~y[2]) & (y[1]) & (~y[0]);
    wire is_011 = (~y[2]) & (y[1]) & (y[0]);

    // next_state[2] = x & (is_001 | is_100)
    wire ns2 = x & (is_001 | is_100);

    // next_state[1] = (x & is_011) | (~x & (is_010 | is_100))
    wire ns1 = (x & is_011) | (~x & (is_010 | is_100));

    // next_state[0] = (y_in_000_or_010 & x) | (~y_in_000_or_010 & ~x)
    wire y_in_000_or_010 = (~y[2]) & (~y[0]);
    wire ns0 = (y_in_000_or_010 & x) | (~y_in_000_or_010 & ~x);

    wire [2:0] next_state = {ns2, ns1, ns0};

    // output z = is_011 | is_100
    assign z = is_011 | is_100;
    assign Y0 = next_state[0];

endmodule