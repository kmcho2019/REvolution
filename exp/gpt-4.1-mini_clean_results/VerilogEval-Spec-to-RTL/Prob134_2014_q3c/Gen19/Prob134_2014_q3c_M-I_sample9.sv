module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode present state y into one-hot signals for defined states
    wire s000 = ~y[2] & ~y[1] & ~y[0];
    wire s001 = ~y[2] & ~y[1] &  y[0];
    wire s010 = ~y[2] &  y[1] & ~y[0];
    wire s011 = ~y[2] &  y[1] &  y[0];
    wire s100 =  y[2] & ~y[1] & ~y[0];

    // Next state bit 2 (ns2): high if (y==001 && x==1) or (y==100 && x==1)
    wire ns2 = (s001 & x) | (s100 & x);

    // Next state bit 1 (ns1):
    // ns1 = (y==010 & x==0) | (y==011 & x==1) | (y==100 & x==0)
    wire ns1 = (s010 & ~x) | (s011 & x) | (s100 & ~x);

    // Next state bit 0 (ns0):
    // ns0 = x if y in {000,010}, else ~x
    wire ns0 = (s000 | s010) ? x : ~x;

    // Next state output vector (for clarity)
    wire [2:0] next_state = {ns2, ns1, ns0};

    // Output z = 1 when present state y is 011 or 100
    // z = s011 | s100
    assign z = s011 | s100;

    // Y0 is bit 0 of next state
    assign Y0 = next_state[0];

endmodule