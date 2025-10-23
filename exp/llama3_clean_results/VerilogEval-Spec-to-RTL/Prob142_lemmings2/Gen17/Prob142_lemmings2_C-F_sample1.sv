module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

typedef enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALL_LEFT,
    FALL_RIGHT
} state_t;

state_t state;
state_t next_state;

// Combinational logic to determine the next state
always_comb begin
    next_state = state;

    case(state)
        WALK_LEFT: 
            if (~ground) begin
                next_state = FALL_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // do nothing, keep walking left
            end
        WALK_RIGHT: 
            if (~ground) begin
                next_state = FALL_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                // do nothing, keep walking right
            end
        FALL_LEFT: 
            if (ground) begin
                next_state = WALK_LEFT;
            end
        FALL_RIGHT: 
            if (ground) begin
                next_state = WALK_RIGHT;
            end
    endcase
end

// Sequential logic to update the state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Output logic using assign statements
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule