module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Enumerate states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Declare current state and next state variables
state_t current_state, next_state;

// Combinational logic block to determine the next state
always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// Sequential logic block to update the current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset to state A
        current_state <= A;
    end else begin
        // Update the current state
        current_state <= next_state;
    end
end

// Define the output based on the current state
always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule