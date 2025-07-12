module TopModule (
    input        clk,    // clock input (unused, included per spec)
    input        x,
    input  [2:0] y,      // present state
    output       Y0,
    output       z
);

    // Decode present state y into one-hot signals for valid states only
    wire s000 = (y == 3'b000);
    wire s001 = (y == 3'b001);
    wire s010 = (y == 3'b010);
    wire s011 = (y == 3'b011);
    wire s100 = (y == 3'b100);

    // Next state bit 2 (ns2) = 1 when (y=001 & x=1) or (y=100 & x=1)
    wire ns2 = (s001 & x) | (s100 & x);

    // Next state bit 1 (ns1) = 1 when (y=010 & ~x) or (y=011 & x) or (y=100 & ~x)
    wire ns1 = (s010 & ~x) | (s011 & x) | (s100 & ~x);

    // Next state bit 0 (ns0) logic:
    // According to table:
    // y=000: ns0 = 0 if x=0, 1 if x=1 --> ns0 = x
    // y=001: ns0 = 1 if x=0, 0 if x=1 --> ns0 = ~x
    // y=010: ns0 = 0 if x=0, 1 if x=1 --> ns0 = x
    // y=011: ns0 = 1 if x=0, 0 if x=1 --> ns0 = ~x
    // y=100: ns0 = 1 (both x=0 and x=1)
    //
    // Implemented as:
    wire ns0 =
        (s000 & x) |
        (s001 & ~x) |
        (s010 & x) |
        (s011 & ~x) |
        (s100);

    // Compose next state vector
    wire [2:0] next_state = {ns2, ns1, ns0};

    // Output z = 1 if present state y is 011 or 100, else 0
    wire z_int = s011 | s100;

    assign z = z_int;
    assign Y0 = next_state[0];

endmodule