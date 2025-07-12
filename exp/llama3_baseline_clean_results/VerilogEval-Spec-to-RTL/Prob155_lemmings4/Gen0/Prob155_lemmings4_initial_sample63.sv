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

// Define the states
enum logic [3:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    DEAD
} state, next_state;

// Define the direction
reg [1:0] direction; // 0: left, 1: right
reg [4:0] fall_count; // count the number of clock cycles the Lemming has been falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
        fall_count <= 0;
        direction <= 0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                    fall_count <= 1;
                end else if (dig) begin
                    state <= DIGGING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_right) begin
                    state <= WALK_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                    direction <= 1;
                end else begin
                    state <= WALK_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            WALK_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                    fall_count <= 1;
                end else if (dig) begin
                    state <= DIGGING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_left) begin
                    state <= WALK_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                    direction <= 0;
                end else begin
                    state <= WALK_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= DEAD;
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        state <= (direction == 0) ? WALK_LEFT : WALK_RIGHT;
                        walk_left <= (direction == 0) ? 1 : 0;
                        walk_right <= (direction == 1) ? 1 : 0;
                        aaah <= 0;
                        digging <= 0;
                    end
                end else begin
                    state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                    fall_count <= fall_count + 1;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                    fall_count <= 1;
                end else begin
                    state <= DIGGING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end
            end
            DEAD: begin
                state <= DEAD;
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
            default: begin
                state <= WALK_LEFT;
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule