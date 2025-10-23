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

enum logic [2:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

logic [5:0] fall_counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            if (ground) begin
                if (fall_counter > 20) begin
                    state <= SPLATTERED;
                end else begin
                    state <= (walk_left == 1)? IDLE_LEFT : IDLE_RIGHT;
                end
                fall_counter <= 0;
            end else begin
                fall_counter <= fall_counter + 1;
            end
        end else if (state == DIGGING) begin
            if (!ground) begin
                state <= FALLING;
            end
        end
    end
end

always_comb begin
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    
    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
            if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1;
            if (bump_right) begin
                next_state = IDLE_LEFT;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            aaah = 1;
        end
        DIGGING: begin
            digging = 1;
        end
        SPLATTERED: begin
            // No action
        end
    endcase
end

endmodule