module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);
    // One-hot encoding of states: A=2'b01, B=2'b10
    reg [1:0] state, next_state;

    // State bits for readability
    wire state_A = state[0];
    wire state_B = state[1];

    // Combinational next state logic
    always @(*) begin
        case (state)
            2'b01: // State A
                if (x)
                    next_state = 2'b10; // Move to B
                else
                    next_state = 2'b01; // Stay in A
            2'b10: // State B
                next_state = 2'b10; // Stay in B
            default:
                next_state = 2'b01; // Default to A on invalid state
        endcase
    end

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // Reset to A
        else
            state <= next_state;
    end

    // Mealy output logic combinational
    always @(*) begin
        case (state)
            2'b01: z = x ? 1'b1 : 1'b0; // In A: z=x
            2'b10: z = x ? 1'b0 : 1'b1; // In B: z=!x
            default: z = 1'b0; // Safe default
        endcase
    end
endmodule