module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // One-hot state encoding: A = 2'b10, B = 2'b01
    reg [1:0] state, next_state;

    // State bits
    wire A = state[1];
    wire B = state[0];

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // B active
        else
            state <= next_state;
    end

    // Next state logic: Moore FSM transitions
    always @(*) begin
        case (state)
            2'b01: // B state
                if (in == 1'b0)
                    next_state = 2'b10; // transition to A
                else
                    next_state = 2'b01; // stay in B
            2'b10: // A state
                if (in == 1'b0)
                    next_state = 2'b01; // transition to B
                else
                    next_state = 2'b10; // stay in A
            default:
                next_state = 2'b01; // default to B for safety
        endcase
    end

    // Moore output depends only on the state
    always @(*) begin
        // Output is 1 when in state B, 0 in state A
        // Because B=2'b01, A=2'b10, so out = state[0]
        out = state[0];
    end

endmodule