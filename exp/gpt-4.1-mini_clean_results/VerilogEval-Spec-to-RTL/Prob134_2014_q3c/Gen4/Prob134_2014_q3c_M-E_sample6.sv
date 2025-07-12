module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode present state y into individual one-hot signals
    wire s0 = (y == 3'b000);
    wire s1 = (y == 3'b001);
    wire s2 = (y == 3'b010);
    wire s3 = (y == 3'b011);
    wire s4 = (y == 3'b100);

    // Compute next state bits Y[2], Y[1], Y[0] as Boolean expressions from FSM table
    // Using the table:
    // Present y | x=0   | x=1    | next_state bits Y[2],Y[1],Y[0]
    // 000       | 000   | 001    | Y2=0,Y1=0,Y0=x (since 0->000, 1->001)
    // 001       | 001   | 100    | Y2=x, Y1=0, Y0=~x (since 0->001,1->100)
    // 010       | 010   | 001    | Y2=0, Y1=1 if x=0 else 0, Y0= x?1:0 
    // 011       | 001   | 010    | Y2=0 if x=0 else 0, Y1= x?1:0, Y0= ~x
    // 100       | 011   | 100    | Y2=x, Y1=1 if x=0 else 0, Y0=1 if x=0 else 0

    // Instead of directly coding from the table, let's express next_state bits as sums of minterms:

    // For Y2:
    // Next_state Y2=1 when:
    // from 001,x=1 -> next_state=100 (Y2=1)
    // from 100,x=1 -> next_state=100 (Y2=1)
    // So,
    // Y2 = s1 & x | s4 & x

    // For Y1:
    // Next_state Y1=1 when:
    // from 010,x=0 -> 010 (Y1=1)
    // from 011,x=1 -> 010 (Y1=1)
    // from 100,x=0 -> 011 (Y1=1)
    // So,
    // Y1 = (s2 & ~x) | (s3 & x) | (s4 & ~x)

    // For Y0:
    // Next_state Y0=1 when:
    // from 000,x=1 -> 001 (Y0=1)
    // from 001,x=0 -> 001 (Y0=1)
    // from 010,x=1 -> 001 (Y0=1)
    // from 011,x=0 -> 001 (Y0=1)
    // from 100,x=0 -> 011 (Y0=1)
    // from 100,x=1 -> 100 (Y0=0)
    // Expressed as:
    // Y0 = (s0 & x) | (s1 & ~x) | (s2 & x) | (s3 & ~x) | (s4 & ~x)

    wire Y2 = (s1 & x) | (s4 & x);
    wire Y1 = (s2 & ~x) | (s3 & x) | (s4 & ~x);
    wire Y0_internal = (s0 & x) | (s1 & ~x) | (s2 & x) | (s3 & ~x) | (s4 & ~x);

    // Output z is 1 only for states 011 or 100
    assign z = s3 | s4;

    assign Y0 = Y0_internal;

endmodule