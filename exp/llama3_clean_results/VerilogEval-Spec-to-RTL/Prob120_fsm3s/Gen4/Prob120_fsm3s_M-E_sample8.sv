module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states using enum
enum logic [1:0] {
    A,
    B,
    C,
    D
} state, next_state;

// Initialize the state to A
initial state = A;

// State transition matrix
always @(*) begin
    case (state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A; // Default to A
    endcase
end

// Output logic
always @(*) begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Default to 0
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule