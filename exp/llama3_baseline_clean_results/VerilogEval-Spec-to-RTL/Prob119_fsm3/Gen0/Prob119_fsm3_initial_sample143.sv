module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
enum logic [1:0] {A, B, C, D} current_state, next_state;

// Assign output based on the current state (Moore machine)
always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Default output for any other state
    endcase
end

// Calculate next state based on current state and input
always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A; // Default next state
    endcase
end

// Update current state on positive edge of clock or reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

endmodule