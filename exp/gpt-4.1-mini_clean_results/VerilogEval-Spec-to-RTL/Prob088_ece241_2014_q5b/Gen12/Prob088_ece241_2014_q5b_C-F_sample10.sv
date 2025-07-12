module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded states stored in a 2-bit vector:
// state[0] = state A, state[1] = state B
reg [1:0] state, next_state;

// Next state logic (combinational)
always @(*) begin
    case (state)
        2'b01: begin // State A
            if (x)
                next_state = 2'b10; // Transition to B
            else
                next_state = 2'b01; // Stay in A
        end
        2'b10: begin // State B
            next_state = 2'b10; // Stay in B regardless of x
        end
        default: begin
            // Safety fallback to reset state
            next_state = 2'b01;
        end
    endcase
end

// Output logic (Mealy FSM), combinational
always @(*) begin
    case (state)
        2'b01: z = x ? 1'b1 : 1'b0;    // In A, z = x
        2'b10: z = ~x ? 1'b1 : 1'b0;   // In B, z = ~x
        default: z = 1'b0;              // Default output safe value
    endcase
end

// State registers with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // Reset to state A
    else
        state <= next_state;
end

endmodule