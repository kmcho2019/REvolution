module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
enum logic [1:0] {A, B, C, D} currentState, nextState;

// Determine the output based on the current state
always_comb begin
    case(currentState)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Determine the next state based on the current state and input
always_comb begin
    case(currentState)
        A: if (!in) nextState = A; else nextState = B;
        B: if (!in) nextState = C; else nextState = B;
        C: if (!in) nextState = A; else nextState = D;
        D: if (!in) nextState = C; else nextState = B;
        default: nextState = A;
    endcase
end

// Update the current state at the positive edge of the clock
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Initialize the current state
initial begin
    currentState = A;
end

endmodule