module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Define state encoding explicitly
reg state_A, state_B; // One-hot encoding

// Initialize state_A and state_B to ensure one-hot encoding
initial begin
    state_A = 1'b1;
    state_B = 1'b0;
end

// Combinational logic for output z
assign z = (state_A && x) || (state_B && ~x);

// Sequential logic for state transitions
always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        // State transitions based on current state and input x
        if(state_A) begin
            if(x) begin
                state_A <= 1'b0;
                state_B <= 1'b1;
            end else begin
                state_A <= 1'b1;
                state_B <= 1'b0;
            end
        end else if(state_B) begin
            // Stay in state B regardless of x
            state_A <= 1'b0;
            state_B <= 1'b1;
        end
    end
end

endmodule