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

enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING} state, next_state;

always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                // do nothing
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1'b1;
            if (bump_right) begin
                next_state = IDLE_LEFT;
            end else if (bump_left) begin
                // do nothing
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (state == IDLE_LEFT) begin
                    next_state = IDLE_LEFT;
                end else if (state == IDLE_RIGHT) begin
                    next_state = IDLE_RIGHT;
                end else if (state == DIGGING) begin
                    next_state = IDLE_LEFT;
                end
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end
        end
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