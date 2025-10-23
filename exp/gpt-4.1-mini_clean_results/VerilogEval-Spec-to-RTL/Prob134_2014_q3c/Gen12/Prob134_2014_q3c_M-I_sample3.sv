module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode present state y into one-hot signals for valid states
    wire s000 = (y == 3'b000);
    wire s001 = (y == 3'b001);
    wire s010 = (y == 3'b010);
    wire s011 = (y == 3'b011);
    wire s100 = (y == 3'b100);

    // Next state bit 2 (ns2) logic:
    // From table:
    // ns2 = 1 only when (y=001 and x=1) or (y=100 and x=1)
    wire ns2 = (s001 & x) | (s100 & x);

    // Next state bit 1 (ns1) logic:
    // ns1=1 when:
    // (y=010 & x=0) or (y=011 & x=1) or (y=100 & x=0)
    wire ns1 = (s010 & ~x) | (s011 & x) | (s100 & ~x);

    // Next state bit 0 (ns0) logic:
    // ns0 = x if y in {000,010} else ~x
    wire ns0 = (s000 | s010) ? x : ~x;

    // Compose next state vector
    wire [2:0] next_state = {ns2, ns1, ns0};

    // Output z logic: high when y=011 or y=100
    wire z_int = s011 | s100;

    assign z = z_int;
    assign Y0 = next_state[0];

endmodule