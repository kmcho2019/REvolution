module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding
    // state[0] = A, state[1] = B
    reg [1:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            2'b01: // State A
                if (x)
                    next_state = 2'b10; // Go to B
                else
                    next_state = 2'b01; // Stay in A
            2'b10: // State B
                next_state = 2'b10; // Stay in B regardless of x
            default:
                next_state = 2'b01; // Safety: default to state A
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // Reset to state A
        else
            state <= next_state;
    end

    // Output combinational logic for Mealy FSM
    // From spec:
    // A --x=0 (z=0)--> A
    // A --x=1 (z=1)--> B
    // B --x=0 (z=1)--> B
    // B --x=1 (z=0)--> B
    assign z = (state[0] & x) | (state[1] & ~x);

endmodule