module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Instead of explicit comparators, encode the 5 states as one-hot using minimal logic:
    // s000 = (y == 3'b000)
    wire s000 = ~y[2] & ~y[1] & ~y[0];
    // s001 = (y == 3'b001)
    wire s001 = ~y[2] & ~y[1] &  y[0];
    // s010 = (y == 3'b010)
    wire s010 = ~y[2] &  y[1] & ~y[0];
    // s011 = (y == 3'b011)
    wire s011 = ~y[2] &  y[1] &  y[0];
    // s100 = (y == 3'b100)
    wire s100 =  y[2] & ~y[1] & ~y[0];

    // Next state bit 2 (ns2):
    // ns2 = (s001 & x) | (s100 & x)
    wire ns2 = (s001 | s100) & x;

    // Next state bit 1 (ns1):
    // ns1 = (s010 & ~x) | (s011 & x) | (s100 & ~x)
    wire ns1 = (s010 & ~x) | (s011 & x) | (s100 & ~x);

    // Next state bit 0 (ns0):
    // From table and analysis:
    // ns0 = (s000 | s010) & x | (~(s000 | s010)) & ~x
    // Expand to avoid ternary:
    wire s000_or_s010 = s000 | s010;
    wire ns0 = (s000_or_s010 & x) | (~s000_or_s010 & ~x);

    // Output z logic:
    // z = s011 | s100
    wire z_int = s011 | s100;

    // Compose next state vector
    wire [2:0] next_state = {ns2, ns1, ns0};

    assign Y0 = next_state[0];
    assign z = z_int;

endmodule