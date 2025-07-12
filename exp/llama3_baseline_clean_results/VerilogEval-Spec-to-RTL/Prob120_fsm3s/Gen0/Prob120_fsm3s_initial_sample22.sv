module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states as an enum
enum logic [1:0] {
    A,
    B,
    C,
    D
} state, next_state;

// Determine the output based on the current state
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

// Handle the state transitions and reset
always_ff @(posedge clk) begin
    if (reset) begin
        // Reset the FSM to state A
        state <= A;
    end else begin
        // Determine the next state based on the current state and input
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
        // Update the current state
        state <= next_state;
    end
end

endmodule