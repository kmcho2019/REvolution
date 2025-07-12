module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg [0:0] state;  // State register with two possible values: 0 (A) and 1 (B)
reg [0:0] next_state;  // Next state variable for the state machine

// Asynchronous reset logic for the state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1;  // Reset to state B (1) when areset is high
    end else begin
        state <= next_state;  // Update state on the positive edge of clk
    end
end

// Combinatorial logic to determine the next state and the output
always @(*) begin
    case (state)
        1'b0: begin  // State A
            if (~in) begin  // Input 'in' is 0
                next_state = 1'b1;  // Transition to state B
            end else begin
                next_state = 1'b0;  // Stay in state A
            end
            out = 1'b0;  // Output 'out' is 0 in state A
        end
        1'b1: begin  // State B
            if (in) begin  // Input 'in' is 1
                next_state = 1'b1;  // Stay in state B
            end else begin
                next_state = 1'b0;  // Transition to state A
            end
            out = 1'b1;  // Output 'out' is 1 in state B
        end
        default: begin
            next_state = 1'b1;  // Default to state B
            out = 1'b1;  // Default output 'out' to 1
        end
    endcase
end

endmodule