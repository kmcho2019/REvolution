module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Enumerate states
typedef enum logic {LEFT = 0, RIGHT = 1} state_t;
state_t state, next_state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

// Define combinational logic
always_comb begin
    case (state)
        LEFT: next_state = bump_left ? RIGHT : LEFT;
        RIGHT: next_state = bump_right ? LEFT : RIGHT;
    endcase
end

// Use assign statements for output logic
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule