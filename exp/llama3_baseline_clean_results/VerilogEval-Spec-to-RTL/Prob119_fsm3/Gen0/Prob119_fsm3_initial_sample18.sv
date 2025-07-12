module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

// Enumerate the states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Declare the current state and next state
state_t current_state, next_state;

// Case statement to define the output values for each state
always_comb begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Sequential logic to update the current state on the positive edge of the clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        // If-else blocks to determine the next state based on the current state and input value
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
        current_state <= next_state;
    end
end

endmodule