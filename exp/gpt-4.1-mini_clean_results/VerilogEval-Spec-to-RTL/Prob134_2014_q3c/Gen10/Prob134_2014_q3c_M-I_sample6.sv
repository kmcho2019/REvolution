module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Define one-hot like signals for known states
    wire s000 = (y == 3'b000);
    wire s001 = (y == 3'b001);
    wire s010 = (y == 3'b010);
    wire s011 = (y == 3'b011);
    wire s100 = (y == 3'b100);

    // For other states (101, 110, 111), we treat as default state 000
    wire s_other = ~(s000 | s001 | s010 | s011 | s100);

    // Next state encoding:
    // next_state[2]:
    // 1 if (y=001 and x=1) or (y=100 and x=1), else 0
    wire ns2 = (s001 & x) | (s100 & x);

    // next_state[1]:
    // 1 if (y=010 and x=0) or (y=011 and x=1) or (y=100 and x=0), else 0
    wire ns1 = (s010 & ~x) | (s011 & x) | (s100 & ~x);

    // next_state[0]:
    // For states 000 and 010, ns0 = x
    // Else if states 001, 011, 100, ns0 = ~x
    // Else for other states default next state is 000 => ns0=0
    wire ns0 = ( (s000 | s010) & x ) | ( (s001 | s011 | s100) & ~x );

    // For undefined states, next state = 000 => ns2=0, ns1=0, ns0=0
    // So override next state bits to zero if s_other is high
    wire next_ns2 = s_other ? 1'b0 : ns2;
    wire next_ns1 = s_other ? 1'b0 : ns1;
    wire next_ns0 = s_other ? 1'b0 : ns0;

    wire [2:0] next_state = {next_ns2, next_ns1, next_ns0};

    // Output z = 1 if present state y is 011 or 100
    // Use one-hot signals s011 or s100 for simplicity and efficiency
    wire z_int = s011 | s100;

    assign z = z_int;
    assign Y0 = next_state[0];

endmodule