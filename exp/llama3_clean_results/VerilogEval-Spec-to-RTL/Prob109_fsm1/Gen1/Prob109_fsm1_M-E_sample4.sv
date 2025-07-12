module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

// Define the states as an enum
typedef enum {B, A} state_type;

// Declare the current and next states
reg [0:0] state;
reg [0:0] next_state;

// Combinational logic to determine next state
always @(*)
begin
    case(state)
        B: // State B
            begin
                if (in == 1) next_state = A; // Go to A
                else next_state = B; // Stay in B
            end
        A: // State A
            begin
                if (in == 0) next_state = B; // Go to B
                else next_state = A; // Stay in A
            end
        default: next_state = B; // Default to state B
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) state <= B; // Reset to state B
    else state <= next_state;
end

// Output logic (Moore machine, output based on current state)
always @(*)
begin
    case(state)
        B: out = 1; // Output 1 in state B
        A: out = 0; // Output 0 in state A
        default: out = 1; // Default output
    endcase
end

endmodule