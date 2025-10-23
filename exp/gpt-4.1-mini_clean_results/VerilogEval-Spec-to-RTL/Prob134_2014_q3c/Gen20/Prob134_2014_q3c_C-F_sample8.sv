module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode only the states needed for next_state[2] logic (y=001, y=100)
    wire s001 = (y == 3'b001);
    wire s100 = (y == 3'b100);

    // next_state bit 2: ns2 = (y=001 and x=1) or (y=100 and x=1)
    wire ns2 = (s001 & x) | (s100 & x);

    // For next_state bit 1 and 0, use boolean expressions on y bits and x directly:

    // next_state bit 1:
    // From FSM table analysis:
    // ns1=1 when (y=010 and x=0) or (y=011 and x=1) or (y=100 and x=0)
    // Implement with minimal comparators using bit patterns:
    // Decode y=010 and y=011:
    wire y_is_010 = (y == 3'b010);
    wire y_is_011 = (y == 3'b011);

    wire ns1 = (y_is_010 & ~x) | (y_is_011 & x) | (s100 & ~x);

    // next_state bit 0:
    // ns0 = x if y in {000, 010}, else ~x
    wire y_is_000 = (y == 3'b000);
    wire ns0 = (y_is_000 | y_is_010) ? x : ~x;

    // next state vector
    wire [2:0] next_state = {ns2, ns1, ns0};

    // Output z is 1 if y=011 or y=100
    wire s011 = y_is_011; // already decoded
    wire z_int = s011 | s100;

    assign z = z_int;
    assign Y0 = next_state[0];

endmodule