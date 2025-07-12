module TopModule(
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

// States
enum logic [2:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Falling counter
reg [5:0] fall_count;

// Direction
reg direction; // 1 for right, 0 for left

always @(*) begin
    next_state = state;
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                // Do nothing
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                // Do nothing
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = (direction) ? IDLE_RIGHT : IDLE_LEFT;
                end
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            // Do nothing
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        direction <= 0;
        fall_count <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        state <= next_state;
        if (state == IDLE_LEFT) begin
            walk_left <= 1;
            walk_right <= 0;
            direction <= 0;
        end else if (state == IDLE_RIGHT) begin
            walk_left <= 0;
            walk_right <= 1;
            direction <= 1;
        end else if (state == FALLING) begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
            fall_count <= fall_count + 1;
        end else if (state == DIGGING) begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end else if (state == SPLATTERED) begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        if (next_state == FALLING) begin
            fall_count <= 1;
        end else if (next_state == IDLE_LEFT || next_state == IDLE_RIGHT || next_state == DIGGING) begin
            fall_count <= 0;
        end
        if (next_state != DIGGING) begin
            digging <= 0;
        end
        if (next_state != FALLING) begin
            aaah <= 0;
        end
    end
end
endmodule