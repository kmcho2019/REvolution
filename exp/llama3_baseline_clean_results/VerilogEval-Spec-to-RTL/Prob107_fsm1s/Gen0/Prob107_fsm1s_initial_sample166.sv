module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states of the machine
reg [0:0] state;  // Using a single bit to represent the two states
reg [0:0] nextState;  // To store the next state

// Assign the output based on the current state
always @(*) begin
    case(state)
        0: out = 1'b1;  // State B
        1: out = 1'b0;  // State A
        default: out = 1'b0;  // Default state
    endcase
end

// Determine the next state based on the current state and input
always @(*) begin
    case(state)
        0: begin  // State B
            if (~in) begin
                nextState = 1;  // Go to state A when in = 0
            end else begin
                nextState = 0;  // Stay in state B when in = 1
            end
        end
        1: begin  // State A
            if (~in) begin
                nextState = 0;  // Go to state B when in = 0
            end else begin
                nextState = 1;  // Stay in state A when in = 1
            end
        end
        default: nextState = 0;  // Default next state
    endcase
end

// Update the current state at the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 0;  // Reset to state B
    end else begin
        state <= nextState;  // Update the current state
    end
end

endmodule