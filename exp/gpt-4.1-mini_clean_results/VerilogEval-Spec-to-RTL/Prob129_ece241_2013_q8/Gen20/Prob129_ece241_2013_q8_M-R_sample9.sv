module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output z
);

    // State encoding: 3 states encoded in 2 bits
    localparam [1:0]
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10;

    reg [1:0] state;
    wire [1:0] next_state;

    // Decode current state bits for clarity
    wire state0 = state[0];
    wire state1 = state[1];

    // Next state logic expressed as boolean equations:
    // From original transitions:
    // S0 (00): next_state = x ? S1 (01) : S0 (00)
    // S1 (01): next_state = x ? S1 (01) : S2 (10)
    // S2 (10): next_state = x ? S1 (01) : S0 (00)
    //
    // So next_state[1] = (state1 & ~state0 & ~x)           // S1=01 and x=0 => S2=10 (bit1=1)
    //                 | (~state1 & state0 & 1'b0)          // no transition from 11 state
    //                 | other conditions (none) ...
    // next_state[0] = (~state1 & ~state0 & x)               // S0=00, x=1 => S1=01 (bit0=1)
    //               | (state1 & ~state0)                     // S1=01 => next_state LSB=1 always when x=1 or 0 (S1 or S2)
    //               | (state1 & ~state0 & ~x)                // S1=01 and x=0 => S2=10 (bit0=0)
    //               | (state1 & ~state0 & x)                 // S1=01 and x=1 => S1=01 (bit0=1)
    //               | (state1 & ~state0 & 1'bx)
    //               Actually from table:
    // next_state[0] = (state == S0 && x) | (state == S1) | (state == S2 && x)
    //
    // Simplify with expressions below.

    // Next_state[1] = 1 when:
    //  - state==S1 (01) and x=0 -> next_state= S2(10) => next_state[1]=1
    // else 0

    assign next_state[1] = (state == S1) && (x == 1'b0);

    // Next_state[0] = 1 when:
    //  - state==S0(00) and x=1 -> next_state= S1(01)
    //  - state==S1(01) and x=1 -> next_state= S1(01)
    //  - state==S2(10) and x=1 -> next_state= S1(01)
    assign next_state[0] = (state == S0 && x) || (state == S1) || (state == S2 && x);

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: asserted when current state is S2 and input x=1
    assign z = (state == S2) && x;

endmodule