module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

// Define states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// Declare current and next state variables
state_t current_state;
state_t next_state;

// Define the state machine's next state logic
always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// Define the state machine's output logic
always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// Define the state machine's sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule