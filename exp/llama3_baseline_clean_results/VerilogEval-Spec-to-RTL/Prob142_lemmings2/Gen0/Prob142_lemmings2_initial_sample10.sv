module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Enum for the states
enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING} state, next_state;

// Signal to remember the direction before falling
logic was_walking_left;

always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;

    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else if (!ground) begin
                next_state = FALLING;
                was_walking_left = 1'b1;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1'b1;
            if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end else if (!ground) begin
                next_state = FALLING;
                was_walking_left = 1'b0;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (was_walking_left) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule