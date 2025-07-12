module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_type;

// Declare the current and next states
state_type current_state, next_state;

// Combinational logic to determine the next state
always @(*) begin
    case (current_state)
        A: next_state = (in == 0) ? A : B;
        B: next_state = (in == 0) ? C : B;
        C: next_state = (in == 0) ? A : D;
        D: next_state = (in == 0) ? C : B;
        default: next_state = A;
    endcase
end

// Sequential logic to update the current state and output
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
    case (current_state)
        A, B, C: out <= 0;
        D: out <= 1;
        default: out <= 0;
    endcase
end

// Initial state
initial begin
    current_state = A;
end

endmodule