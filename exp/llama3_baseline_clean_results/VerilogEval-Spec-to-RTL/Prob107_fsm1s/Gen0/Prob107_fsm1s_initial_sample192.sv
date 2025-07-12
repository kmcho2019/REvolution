module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
enum {A, B} state, next_state;

always @(*) begin
    // Determine the next state based on the current state and input
    case (state)
        A: next_state = in ? A : B;
        B: next_state = in ? B : A;
    endcase
end

always @(posedge clk) begin
    // If reset is high, reset the state machine to state B
    if (reset) begin
        state <= B;
    end
    // Otherwise, transition to the next state
    else begin
        state <= next_state;
    end
end

// Determine the output based on the current state
always @(*) begin
    case (state)
        A: out = 0;
        B: out = 1;
    endcase
end

endmodule