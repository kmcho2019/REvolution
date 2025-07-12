module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // One-hot state encoding: state[0] = A, state[1] = B
    reg [1:0] state;
    reg [1:0] next_state;

    // Simplified next state logic
    always @(*) begin
        case (state)
            2'b01: next_state = x ? 2'b10 : 2'b01;  // State A transitions
            2'b10: next_state = 2'b10;              // State B always stays
            default: next_state = 2'b01;            // Default to state A
        endcase
    end

    // Registered output for better timing
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A (one-hot)
            z <= 0;
        end
        else begin
            state <= next_state;
            // Output depends only on current state (Mealy)
            case (state)
                2'b01: z <= x;      // State A: output equals input
                2'b10: z <= ~x;     // State B: output equals inverted input
                default: z <= 0;
            endcase
        end
    end

endmodule