module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

enum logic [2:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

reg [5:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_counter <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (!ground) begin
                    next_state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig) begin
                    next_state <= DIGGING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_right) begin
                    next_state <= IDLE_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_left) begin
                    next_state <= IDLE_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end else begin
                    next_state <= IDLE_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            IDLE_RIGHT: begin
                if (!ground) begin
                    next_state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig) begin
                    next_state <= DIGGING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_left) begin
                    next_state <= IDLE_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_right) begin
                    next_state <= IDLE_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end else begin
                    next_state <= IDLE_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state <= SPLATTERED;
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else if (state == IDLE_LEFT) begin
                        next_state <= IDLE_LEFT;
                        walk_left <= 1;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        next_state <= IDLE_RIGHT;
                        walk_left <= 0;
                        walk_right <= 1;
                        aaah <= 0;
                        digging <= 0;
                    end
                end else begin
                    next_state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end
                if (ground) begin
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else begin
                    next_state <= DIGGING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end
            end
            SPLATTERED: begin
                next_state <= SPLATTERED;
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
            default: begin
                next_state <= IDLE_LEFT;
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
        state <= next_state;
    end
end