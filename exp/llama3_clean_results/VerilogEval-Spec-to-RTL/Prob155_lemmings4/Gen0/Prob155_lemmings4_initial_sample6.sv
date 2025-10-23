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

// Define states
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Define falling counter
reg [5:0] falling_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        falling_counter <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            falling_counter <= falling_counter + 1;
        end else begin
            falling_counter <= 0;
        end
    end
end

always @(*) begin
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    
    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (falling_counter > 20) begin
                    next_state = SPLATTERED;
                end else if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else if (state == WALK_RIGHT) begin
                    next_state = WALK_RIGHT;
                end else if (state == DIGGING) begin
                    next_state = WALK_LEFT;
                end
            end
        end
        DIGGING: begin
            digging = 1;
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule