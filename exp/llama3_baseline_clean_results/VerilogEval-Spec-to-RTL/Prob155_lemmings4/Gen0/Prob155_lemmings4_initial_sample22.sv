module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

logic [4:0] fall_counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 5'b0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            if (ground) begin
                if (fall_counter > 5'b10000) begin // 20 clock cycles
                    state <= SPLATTERED;
                end else begin
                    // resume walking in the same direction as before the fall
                    if (next_state == WALK_LEFT) begin
                        state <= WALK_LEFT;
                    end else if (next_state == WALK_RIGHT) begin
                        state <= WALK_RIGHT;
                    end
                end
                fall_counter <= 5'b0;
            end else begin
                fall_counter <= fall_counter + 1'b1;
            end
        end else if (state == DIGGING) begin
            if (!ground) begin
                state <= FALLING;
            end
        end
    end
end

always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    
    next_state = state;
    
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end
            walk_right = 1'b1;
        end
        FALLING: begin
            if (ground) begin
                // do nothing, handled in the sequential logic
            end
            aaah = 1'b1;
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
            digging = 1'b1;
        end
        SPLATTERED: begin
            // do nothing, stay in this state
        end
    endcase
    
    if (state == SPLATTERED) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
    end
end

endmodule