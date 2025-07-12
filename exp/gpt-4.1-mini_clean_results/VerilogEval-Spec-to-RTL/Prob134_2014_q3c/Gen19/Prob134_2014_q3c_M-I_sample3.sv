module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode present state y into one-hot signals for defined states only
    wire s000 = (y == 3'b000);
    wire s001 = (y == 3'b001);
    wire s010 = (y == 3'b010);
    wire s011 = (y == 3'b011);
    wire s100 = (y == 3'b100);

    // Next state bit 2 logic:
    // From the table:
    // ns2 = 1 only if (y=001 and x=1) or (y=100 and x=1)
    wire ns2 = (s001 & x) | (s100 & x);

    // Next state bit 1 logic:
    // ns1 = 1 when (y=010 and x=0) or (y=011 and x=1) or (y=100 and x=0)
    wire ns1 = (s010 & ~x) | (s011 & x) | (s100 & ~x);

    // Next state bit 0 logic:
    // For y in {000,010} ns0 = x, else ns0 = ~x
    wire ns0 = (s000 | s010) ? x : ~x;

    // Next state vector
    wire [2:0] next_state = {ns2, ns1, ns0};

    // Output z is 1 if y = 011 or 100
    wire z_int = s011 | s100;

    assign z = z_int;
    assign Y0 = next_state[0];

endmodule