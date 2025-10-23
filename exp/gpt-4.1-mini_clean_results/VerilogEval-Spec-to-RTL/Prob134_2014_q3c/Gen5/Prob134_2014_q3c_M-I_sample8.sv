module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode current states for convenience
    wire s0 = (y == 3'b000);
    wire s1 = (y == 3'b001);
    wire s2 = (y == 3'b010);
    wire s3 = (y == 3'b011);
    wire s4 = (y == 3'b100);

    // Output z is 1 for states 011 and 100
    assign z = s3 | s4;

    // Next state bits derived from the FSM table:
    // Using the table:
    // y | x=0 | x=1 | next_state (binary)
    // 000 | 000 | 001
    // 001 | 001 | 100
    // 010 | 010 | 001
    // 011 | 001 | 010
    // 100 | 011 | 100

    // Let's write expressions for each bit of next_state:

    // next_state[2]:
    // From table, bit 2 is 0 for 000, 001(x=0), 010, 011(x=0), and 100(x=1)
    // Actually, check where bit2 = 1:
    // next_state:
    // 000 x=1 => 001 -> bit2=0
    // 001 x=1 => 100 -> bit2=1
    // 011 x=0 => 001 -> bit2=0
    // 100 x=0 => 011 -> bit2=0
    // 100 x=1 => 100 -> bit2=1
    //
    // Simplify:
    // next_state[2] = (y == 3'b001 & x == 1) | (y == 3'b100 & x == 1)
    // Since both are y=001 or y=100 and x=1
    // next_state[2] = ( (s1 | s4) & x )

    assign next_state[2] = ( (s1 | s4) & x );

    // next_state[1]:
    // next_state:
    // 000 x=0 => 000 -> bit1=0
    // 000 x=1 => 001 -> bit1=0
    // 001 x=0 => 001 -> bit1=0
    // 001 x=1 => 100 -> bit1=0
    // 010 x=0 => 010 -> bit1=1
    // 010 x=1 => 001 -> bit1=0
    // 011 x=0 => 001 -> bit1=0
    // 011 x=1 => 010 -> bit1=1
    // 100 x=0 => 011 -> bit1=1
    // 100 x=1 => 100 -> bit1=0
    //
    // Observe when bit1=1:
    // (y=010 & x=0), (y=011 & x=1), (y=100 & x=0)
    //
    // So:
    // next_state[1] = (s2 & ~x) | (s3 & x) | (s4 & ~x)

    assign next_state[1] = (s2 & ~x) | (s3 & x) | (s4 & ~x);

    // next_state[0]:
    // next_state:
    // 000 x=0 => 000 -> bit0=0
    // 000 x=1 => 001 -> bit0=1
    // 001 x=0 => 001 -> bit0=1
    // 001 x=1 => 100 -> bit0=0
    // 010 x=0 => 010 -> bit0=0
    // 010 x=1 => 001 -> bit0=1
    // 011 x=0 => 001 -> bit0=1
    // 011 x=1 => 010 -> bit0=0
    // 100 x=0 => 011 -> bit0=1
    // 100 x=1 => 100 -> bit0=0
    //
    // Bit0=1 for:
    // (000 & x=1), (001 & x=0), (010 & x=1), (011 & x=0), (100 & x=0)
    //
    // So:
    // next_state[0] = (s0 & x) | (s1 & ~x) | (s2 & x) | (s3 & ~x) | (s4 & ~x)

    assign next_state[0] = (s0 & x) | (s1 & ~x) | (s2 & x) | (s3 & ~x) | (s4 & ~x);

    // Output Y0 is LSB of next_state
    assign Y0 = next_state[0];

endmodule