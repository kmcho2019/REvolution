module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic out
);

// Enumerate the states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// Current state and next state
state_t current_state, next_state;

// Always block to handle state transitions
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to determine next state and output
always_comb begin
    case (current_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
    endcase

    // Determine output based on current state
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule