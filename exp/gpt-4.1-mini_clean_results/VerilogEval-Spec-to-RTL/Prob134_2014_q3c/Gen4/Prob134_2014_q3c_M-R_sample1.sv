module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    wire [2:0] next_state;

    // next_state[2] logic:
    // From table:
    // y=000: next_state=000 if x=0, 001 if x=1 => next_state[2]=0
    // y=001: next_state=001 if x=0, 100 if x=1 => next_state[2]= (x & ~y[0] & ~y[1]) == x & (y==001)
    // y=010: next_state=010 if x=0, 001 if x=1 => next_state[2]= y[1] & ~x
    // y=011: next_state=001 if x=0, 010 if x=1 => next_state[2]= y==011 & x?0:0 actually next_state[2]= y[1] & x, from 010
    // y=100: next_state=011 if x=0, 100 if x=1 => next_state[2]= (~x & 3'b011) or (x & 3'b100)

    // Construct next_state bits logically:

    // Using simple if-else logic turned into expressions for each bit:

    // next_state[2]:
    // It's '1' only in next_state=100 or 011
    // From table:
    // When y=001 and x=1 => 100 (bit2=1)
    // When y=100 and x=0 => 011 (bit2=0)
    // When y=100 and x=1 => 100 (bit2=1)
    // When y=010 and x=0 => 010 (bit2=0)
    // When y=011 and x=1 => 010 (bit2=0)
    // Simplify:
    // next_state[2] = (y==001 & x) | (y==100 & x)

    assign next_state[2] = ((y == 3'b001) & x) | ((y == 3'b100) & x);

    // next_state[1]:
    // next_state examples:
    // y=000: next_state = 000 or 001 => bit1=0
    // y=001: next_state = 001 or 100 => bit1 = 0 or 0
    // y=010: next_state = 010 or 001 => bit1 = 1 or 0
    // y=011: next_state = 001 or 010 => bit1 = 0 or 1
    // y=100: next_state = 011 or 100 => bit1 = 1 or 0
    // So next_state[1] = (y == 010 & ~x) | (y == 011 & x) | (y == 100 & ~x)

    assign next_state[1] = ((y == 3'b010) & ~x) | ((y == 3'b011) & x) | ((y == 3'b100) & ~x);

    // next_state[0]:
    // From table:
    // y=000: next_state = 000 or 001 => bit0 = 0 or 1
    // y=001: next_state = 001 or 100 => bit0 = 1 or 0
    // y=010: next_state = 010 or 001 => bit0 = 0 or 1
    // y=011: next_state = 001 or 010 => bit0 = 1 or 0
    // y=100: next_state = 011 or 100 => bit0 = 1 or 0
    // next_state[0] = (~x & y==000) | (~x & y==001) | (x & y==000) | (x & y==010) | (~x & y==011)

    assign next_state[0] = 
          ((~x) & (y == 3'b000)) |
          ((~x) & (y == 3'b001)) |
          (x & (y == 3'b000)) |
          (x & (y == 3'b010)) |
          ((~x) & (y == 3'b011));

    // Output z = 1 when y==011 or y==100
    assign z = (y == 3'b011) | (y == 3'b100);

    // Output Y0 = LSB of next_state
    assign Y0 = next_state[0];

endmodule