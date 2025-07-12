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

// Define the states
enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALL_LEFT,
    FALL_RIGHT
} state, next_state;

// Output logic
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (bump_left) next_state = WALK_RIGHT;
            else if (!ground) next_state = FALL_LEFT;
        end
        WALK_RIGHT: begin
            if (bump_right) next_state = WALK_LEFT;
            else if (!ground) next_state = FALL_RIGHT;
        end
        FALL_LEFT: begin
            if (ground) next_state = WALK_LEFT;
        end
        FALL_RIGHT: begin
            if (ground) next_state = WALK_RIGHT;
        end
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule