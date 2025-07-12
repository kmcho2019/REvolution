module TopModule (
    input        clk,    // clock input (not used)
    input        x,
    input  [2:0] y,      // present state
    output       Y0,
    output       z
);

    // Decode next state bits using combinational logic derived from table:
    // next_state[2]:
    // - y=000,x=0 -> 0,  x=1 -> 0
    // - y=001,x=0 -> 0,  x=1 -> 1
    // - y=010,x=0 -> 0,  x=1 -> 0
    // - y=011,x=0 -> 0,  x=1 -> 0
    // - y=100,x=0 -> 0,  x=1 -> 1
    // From this, next_state[2] = (y==001 & x) | (y==100 & x) 
    wire y_is_001 = (y == 3'b001);
    wire y_is_100 = (y == 3'b100);
    wire next2 = (y_is_001 & x) | (y_is_100 & x);

    // next_state[1]:
    // y=000,x=0 -> 0, x=1->0
    // y=001,x=0 ->0, x=1->0
    // y=010,x=0 ->1, x=1->0
    // y=011,x=0 ->0, x=1->1
    // y=100,x=0 ->1, x=1->0
    // next1= ( (y==010 & ~x) | (y==011 & x) | (y==100 & ~x) )
    wire y_is_010 = (y == 3'b010);
    wire y_is_011 = (y == 3'b011);
    wire next1 = ( (y_is_010 & ~x) | (y_is_011 & x) | (y_is_100 & ~x) );

    // next_state[0]:
    // y=000,x=0->0, x=1->1
    // y=001,x=0->1, x=1->0
    // y=010,x=0->0, x=1->1
    // y=011,x=0->1, x=1->0
    // y=100,x=0->1, x=1->0
    // next0 = ( (y==001 & ~x) | (y==011 & ~x) | (y==100 & ~x) | (y==000 & x) | (y==010 & x) )
    wire y_is_000 = (y == 3'b000);
    wire next0 = ( (y_is_001 & ~x) | (y_is_011 & ~x) | (y_is_100 & ~x) | (y_is_000 & x) | (y_is_010 & x) );

    // Output z = 1 if present state y is 011 or 100, else 0
    assign z = (y == 3'b011) | (y == 3'b100);

    // Assign Y0 as LSB of next_state
    assign Y0 = next0;

endmodule