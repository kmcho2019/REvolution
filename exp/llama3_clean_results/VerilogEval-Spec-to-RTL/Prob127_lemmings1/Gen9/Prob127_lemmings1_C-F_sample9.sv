module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
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
    if (bump_left && bump_right) begin
        next_state = (state == LEFT) ? RIGHT : LEFT;
    end else if (bump_left) begin
        next_state = RIGHT;
    end else if (bump_right) begin
        next_state = LEFT;
    end else begin
        next_state = state;
    end
end

// Use assign statements for output logic
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule