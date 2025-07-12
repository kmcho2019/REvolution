module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING_LEFT = 3'b100,
    DIGGING_RIGHT = 3'b101
} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always_comb begin
    next_state = state;

    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // No change
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // No change
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALK_LEFT; // Default to walking left
            end
        end
        DIGGING_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

// Output logic
always_comb begin
    walk_left = (state == WALK_LEFT || state == DIGGING_LEFT)? 1'b1 : 1'b0;
    walk_right = (state == WALK_RIGHT || state == DIGGING_RIGHT)? 1'b1 : 1'b0;
    aaah = (state == FALLING)? 1'b1 : 1'b0;
    digging = (state == DIGGING_LEFT || state == DIGGING_RIGHT)? 1'b1 : 1'b0;
end

endmodule