module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

// Define an enumeration for the states
typedef enum {LEFT, RIGHT} state_t;

reg state; // Using a 1-bit state variable
reg next_state; // Using a separate next_state variable

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
    end else begin
        state <= next_state;
    end
end

// Use combinational logic to determine the next state
always_comb begin
    case (state)
        LEFT: next_state = (bump_left) ? RIGHT : LEFT;
        RIGHT: next_state = (bump_right) ? LEFT : RIGHT;
        default: next_state = LEFT; // Default to LEFT state
    endcase
end

// Use assign statements for output logic
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule