module TopModule (
    input        clk,     // clock input (unused)
    input        x,
    input  [2:0] y,       // present state
    output       Y0,
    output       z
);

    // One-hot decode the present state y for valid states only
    wire s000 = (y == 3'b000);
    wire s001 = (y == 3'b001);
    wire s010 = (y == 3'b010);
    wire s011 = (y == 3'b011);
    wire s100 = (y == 3'b100);

    // Next state bits logic derived from table and one-hot signals

    // ns2 = 1 if (y=001 & x=1) or (y=100 & x=1)
    wire ns2 = (s001 & x) | (s100 & x);

    // ns1 = 1 if (y=010 & x=0) or (y=011 & x=1) or (y=100 & x=0)
    wire ns1 = (s010 & ~x) | (s011 & x) | (s100 & ~x);

    // ns0 = 1 if ( (y=000 or y=010) & x=1 ) or ( (y=001 or y=011 or y=100) & x=0 )
    wire ns0 = ((s000 | s010) & x) | ((s001 | s011 | s100) & ~x);

    // Compose next_state vector
    wire [2:0] next_state = {ns2, ns1, ns0};

    // Output z = 1 if present state y is 011 or 100
    wire z_int = s011 | s100;

    assign Y0 = next_state[0];
    assign z = z_int;

endmodule