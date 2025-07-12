module TopModule (
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
enum logic [1:0] {IDLE, WALK_LEFT, WALK_RIGHT, FALLING} state, next_state;

// Keep track of the previous walking direction
logic prev_walk_left;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_walk_left <= 1'b1;
    end else begin
        state <= next_state;
        if (state == FALLING && ground) begin
            prev_walk_left <= prev_walk_left;
        end else if (ground && (bump_left || bump_right)) begin
            if (state == WALK_LEFT && bump_left) begin
                prev_walk_left <= 1'b0;
            end else if (state == WALK_RIGHT && bump_right) begin
                prev_walk_left <= 1'b1;
            end
        end
    end
end

always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    next_state = state;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (bump_left) begin
                next_state = WALK_RIGHT;
                prev_walk_left = 1'b0;
            end else if (!ground) begin
                next_state = FALLING;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (bump_right) begin
                next_state = WALK_LEFT;
                prev_walk_left = 1'b1;
            end else if (!ground) begin
                next_state = FALLING;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (prev_walk_left) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
        end
    endcase
end

endmodule