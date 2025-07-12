module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

reg [1:0] state; // State variable, 2 bits to represent two states (A, B)

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset to state B
        state <= 1; // State B is represented by '1'
    end else begin
        case (state)
            1: // State B
                if (in == 0) state <= 0; // Transition to A on input '0'
                else state <= 1; // Stay in B on input '1'
            0: // State A
                if (in == 0) state <= 1; // Transition to B on input '0'
                else state <= 0; // Stay in A on input '1'
            default:
                state <= 1; // Default to state B if state is undefined
        endcase
    end
end

// Output logic based on the current state
always @(*) begin
    case (state)
        1: out = 1; // Output '1' when in state B
        0: out = 0; // Output '0' when in state A
        default: out = 1; // Default output to '1' if state is undefined
    endcase
end

endmodule