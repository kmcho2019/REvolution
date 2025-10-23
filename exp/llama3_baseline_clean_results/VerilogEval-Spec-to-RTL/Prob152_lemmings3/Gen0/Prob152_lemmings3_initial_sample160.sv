module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [1:0] {
    IDLE_LEFT = 2'b00,
    IDLE_RIGHT = 2'b01,
    FALLING = 2'b10,
    DIGGING_LEFT = 2'b11,
    DIGGING_RIGHT = 2'b00
} state, next_state;

// Initialize the outputs
assign walk_left = (state == IDLE_LEFT || state == DIGGING_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == IDLE_RIGHT || state == DIGGING_RIGHT) ? 1'b1 : 1'b0;
assign aaah = (state == FALLING) ? 1'b1 : 1'b0;
assign digging = (state == DIGGING_LEFT || state == DIGGING_RIGHT) ? 1'b1 : 1'b0;

// State machine logic
always_comb begin
    next_state = state;

    case (state)
        IDLE_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_LEFT;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                // do nothing
            end
        end

        IDLE_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bump_left) begin
                // do nothing
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end
        end

        FALLING: begin
            if (ground) begin
                if (state == FALLING && bump_left && bump_right) begin
                    next_state = (state == DIGGING_LEFT) ? IDLE_RIGHT : (state == DIGGING_RIGHT) ? IDLE_LEFT : IDLE_LEFT;
                end else if (state == FALLING && bump_left) begin
                    next_state = (state == DIGGING_LEFT) ? IDLE_RIGHT : IDLE_LEFT;
                end else if (state == FALLING && bump_right) begin
                    next_state = (state == DIGGING_RIGHT) ? IDLE_LEFT : IDLE_RIGHT;
                end else if (state == DIGGING_LEFT) begin
                    next_state = IDLE_LEFT;
                end else if (state == DIGGING_RIGHT) begin
                    next_state = IDLE_RIGHT;
                end else begin
                    next_state = (state == FALLING && bump_left) ? IDLE_RIGHT : (state == FALLING && bump_right) ? IDLE_LEFT : IDLE_LEFT;
                end
            end
        end

        DIGGING_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                // do nothing
            end
        end

        DIGGING_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                // do nothing
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end
        end

        default: begin
            next_state = IDLE_LEFT;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule