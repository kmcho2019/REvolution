module TopModule (
    input        clk,    // clock input (unused in combinational FSM logic)
    input        x,
    input  [2:0] y,      // present state
    output reg   Y0,
    output reg   z
);

    always @(*) begin
        // Compute output z directly: z = 1 if y == 3'b011 or y == 3'b100
        z = (y == 3'b011) || (y == 3'b100);

        // Compute Y0 as next_state[0] without forming full next_state
        // Derive Y0 from the next state table:

        // From the table (present y / x => next_state):
        // y=000: x=0->000, x=1->001  => next_state[0] = x
        // y=001: x=0->001, x=1->100  => next_state[0] = (x==0)?1:0
        // y=010: x=0->010, x=1->001  => next_state[0] = (x==0)?0:1
        // y=011: x=0->001, x=1->010  => next_state[0] = (x==0)?1:0
        // y=100: x=0->011, x=1->100  => next_state[0] = (x==0)?1:0

        // Implementing as a conditional expression:
        case (y)
            3'b000: Y0 = x;
            3'b001: Y0 = ~x;        // 1 when x=0, else 0
            3'b010: Y0 = x;         // next_state[0] = 0 if x=0 else 1; so equals x
            3'b011: Y0 = ~x;
            3'b100: Y0 = ~x;
            default: Y0 = 1'b0;
        endcase
    end

endmodule