module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states
enum logic [1:0] {
    IDLE_LEFT,
    IDLE_RIGHT,
    FALLING,
    DIGGING_LEFT,
    DIGGING_RIGHT
} state, next_state;

// Keep track of the current direction
logic direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        direction <= 1'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        walk_left <= direction ? 1'b0 : 1'b1;
        walk_right <= direction ? 1'b1 : 1'b0;
        aaah <= state == FALLING ? 1'b1 : 1'b0;
        digging <= state == DIGGING_LEFT || state == DIGGING_RIGHT ? 1'b1 : 1'b0;
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
                direction = 1'b1;
            end else if (bump_left) begin
                // No change
            end
        end
        IDLE_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
                direction = 1'b0;
            end else if (bump_right) begin
                // No change
            end
        end
        FALLING: begin
            if (ground) begin
                if (direction) begin
                    next_state = IDLE_RIGHT;
                end else begin
                    next_state = IDLE_LEFT;
                end
            end
        end
        DIGGING_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (~dig) begin
                next_state = IDLE_LEFT;
            end
        end
        DIGGING_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (~dig) begin
                next_state = IDLE_RIGHT;
            end
        end
    endcase
end

endmodule