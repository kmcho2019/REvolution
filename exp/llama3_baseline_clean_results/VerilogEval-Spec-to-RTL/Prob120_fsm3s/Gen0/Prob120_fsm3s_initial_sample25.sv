module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states as an enumeration
enum logic [1:0] {
    A,
    B,
    C,
    D
} state, next_state;

// Output is determined by the current state
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Default to 0 for invalid states
    endcase
end

// State transitions based on current state and input
always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A; // Default to A for invalid states
    endcase
end

// Synchronous active high reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule