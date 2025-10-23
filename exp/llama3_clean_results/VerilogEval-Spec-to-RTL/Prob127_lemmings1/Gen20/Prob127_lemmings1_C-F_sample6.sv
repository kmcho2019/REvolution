module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

// Define an enumeration for the states
typedef enum {WALK_LEFT, WALK_RIGHT} state_t;

// Use a 1-bit state variable
logic state;

// Use a single always block for sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Initialize state to WALK_LEFT
    end else begin
        if (bump_left && !bump_right) begin
            state <= 1'b0; // Walk right
        end else if (bump_right && !bump_left) begin
            state <= 1'b1; // Walk left
        end else if (bump_left && bump_right) begin
            state <= ~state; // Toggle state
        end
    end
end

// Use assign statements for output logic
assign walk_left = state;
assign walk_right = ~state;

endmodule