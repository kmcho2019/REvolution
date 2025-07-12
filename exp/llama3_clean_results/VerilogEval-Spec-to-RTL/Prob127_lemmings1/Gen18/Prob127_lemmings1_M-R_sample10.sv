module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define an enumeration for the states
typedef enum logic {LEFT = 0, RIGHT = 1} state_t;

reg state; // Using a 1-bit state variable

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
    end else begin
        // Update state based on current state and inputs
        state <= (bump_left && state == LEFT) || (bump_right && state == RIGHT)? ~state : state;
    end
end

// Output logic using assign
assign walk_left = ~state;
assign walk_right = state;

endmodule