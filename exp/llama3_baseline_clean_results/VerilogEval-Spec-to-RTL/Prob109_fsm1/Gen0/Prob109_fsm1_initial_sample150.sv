module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

// Define the states
typedef enum logic [0:0] {
    B,
    A
} state_t;

// Current and next state variables
state_t current_state;
state_t next_state;

// Combinational logic for next state
always_comb begin
    case (current_state)
        B: next_state = (in) ? B : A;
        A: next_state = (in) ? A : B;
        default: next_state = B;
    endcase
end

// Sequential logic for state update
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign out = (current_state == A) ? 0 : 1;

endmodule