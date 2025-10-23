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

// Use a single always block for sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
    end else begin
        if (bump_left && bump_right) begin
            state <= (state == LEFT) ? RIGHT : LEFT; // Switch direction
        end else if (state == LEFT) begin // LEFT state
            state <= bump_left ? RIGHT : LEFT; // RIGHT state if bumped, else stay
        end else begin // RIGHT state
            state <= bump_right ? LEFT : RIGHT; // LEFT state if bumped, else stay
        end
    end
end

// Use assign statements for output logic
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule