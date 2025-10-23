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

enum {IDLE, WALK_LEFT, WALK_RIGHT, FALLING} state, next_state;

always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if(ground) begin
                next_state = WALK_LEFT;
            end
        end
        WALK_LEFT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(bump_left) begin
                next_state = WALK_RIGHT;
            end
        end
        WALK_RIGHT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        FALLING: begin
            if(ground) begin
                next_state = WALK_LEFT;
            end
        end
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= WALK_LEFT;
    end else begin
        if(bump_left && bump_right) begin
            if(state == WALK_LEFT) begin
                state <= WALK_RIGHT;
            end else if(state == WALK_RIGHT) begin
                state <= WALK_LEFT;
            end
        end else begin
            state <= next_state;
        end
    end
end

always_comb begin
    case(state)
        IDLE: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
        end
        WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
    endcase
end

endmodule