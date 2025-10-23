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

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
    end else begin
        case (state)
            LEFT: state <= (bump_left || bump_right) ? RIGHT : LEFT;
            RIGHT: state <= (bump_left || bump_right) ? LEFT : RIGHT;
        endcase
    end
end

// Use assign statements for output logic
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule