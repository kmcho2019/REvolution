module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Next state bits derived from present state y and input x
    // Instead of case statement, use combinational expressions based on table analysis
    // Define next_state[2], next_state[1], next_state[0] independently

    // From FSM table analysis:
    // next_state bit 2 depends mostly on y and x as follows:
    // y=000: next state when x=0:000 (bit2=0), x=1:001(bit2=0)
    // y=001: next state x=0:001(bit2=0), x=1:100(bit2=1)
    // y=010: next state x=0:010(bit2=0), x=1:001(bit2=0)
    // y=011: next state x=0:001(bit2=0), x=1:010(bit2=0)
    // y=100: next state x=0:011(bit2=0), x=1:100(bit2=1)
    // So next_state[2] = (y == 3'b001 && x) || (y == 3'b100 && x)

    wire ns2 = ( (y == 3'b001) && x ) || ( (y == 3'b100) && x );

    // next_state bit 1:
    // y=000: 000 or 001 -> bit1=0
    // y=001: 001 or 100 -> 0 or 0
    // y=010: 010 or 001 -> 1 or 0
    // y=011: 001 or 010 -> 0 or 1
    // y=100: 011 or 100 -> 1 or 0
    // Expression for ns1:
    // ns1= (y==010 && x==0) || (y==011 && x==1) || (y==100 && x==0)

    wire ns1 = ( (y == 3'b010) && (x == 1'b0) ) 
             || ( (y == 3'b011) && (x == 1'b1) )
             || ( (y == 3'b100) && (x == 1'b0) );

    // next_state bit 0:
    // From table:
    // y=000: next state 000 or 001 -> bit0=0 or 1 (bit0=x when y=000)
    // y=001: 001 or 100 -> 1 or 0 (bit0 = ~x when y=001)
    // y=010: 010 or 001 -> 0 or 1 (bit0 = x when y=010)
    // y=011: 001 or 010 -> 1 or 0 (bit0 = ~x when y=011)
    // y=100: 011 or 100 -> 1 or 0 (bit0 = ~x when y=100)
    // So bit0 logic: when y in {000,010} ns0 = x, else ns0 = ~x

    wire y_is_000_or_010 = (y == 3'b000) || (y == 3'b010);
    wire ns0 = y_is_000_or_010 ? x : ~x;

    // Next state vector
    wire [2:0] next_state = {ns2, ns1, ns0};

    // Output z is high if present state y is 011 or 100
    // Implement as a simple logic to save gates

    wire z_int = (y[2] & ~y[1] & ~y[0]) | (~y[2] & y[1] & y[0]); // 100 or 011

    assign z = z_int;

    // Y0 is bit0 of next_state
    assign Y0 = next_state[0];

endmodule