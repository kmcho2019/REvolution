module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);
    // One-hot encoded states: 2-bit vector
    // state[1] = state B, state[0] = state A
    reg [1:0] state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // Reset to state A: 01
        else
            state <= next_state;
    end

    // Next state combinational logic
    // From A (state[0] = 1): if x=1 -> B; else stay A
    // From B (state[1] = 1): stay B regardless of x
    always @(*) begin
        case (state)
            2'b01: next_state = x ? 2'b10 : 2'b01; // A to B or stay A
            2'b10: next_state = 2'b10;              // stay B
            default: next_state = 2'b01;            // safety fallback to A
        endcase
    end

    // Mealy output logic: z depends on current state and x
    // In A: z = x; in B: z = ~x
    assign z = (state[0]) ? x : ~x;

endmodule