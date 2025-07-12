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

// Enumerations for states
enum logic [2:0] {
    IDLE_LEFT,
    WALKING_LEFT,
    WALKING_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Variables to keep track of direction and fall counter
logic [1:0] direction;
logic [5:0] fall_counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_counter <= 0;
        direction <= 2'b00; // 2'b00: left, 2'b01: right
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (bump_left) begin
                    state <= WALKING_RIGHT;
                    direction <= 2'b01;
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                    direction <= 2'b00;
                end else if (dig) begin
                    state <= DIGGING;
                    direction <= 2'b00;
                end else if (!ground) begin
                    state <= FALLING;
                    direction <= 2'b00;
                end else begin
                    state <= WALKING_LEFT;
                    direction <= 2'b00;
                end
            end
            WALKING_LEFT: begin
                if (bump_left) begin
                    state <= WALKING_RIGHT;
                    direction <= 2'b01;
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                    direction <= 2'b00;
                end else if (dig) begin
                    state <= DIGGING;
                    direction <= 2'b00;
                end else if (!ground) begin
                    state <= FALLING;
                    direction <= 2'b00;
                end
            end
            WALKING_RIGHT: begin
                if (bump_left) begin
                    state <= WALKING_LEFT;
                    direction <= 2'b00;
                end else if (bump_right) begin
                    state <= WALKING_RIGHT;
                    direction <= 2'b01;
                end else if (dig) begin
                    state <= DIGGING;
                    direction <= 2'b01;
                end else if (!ground) begin
                    state <= FALLING;
                    direction <= 2'b01;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= SPLATTERED;
                    end else begin
                        if (direction == 2'b00) begin
                            state <= WALKING_LEFT;
                        end else begin
                            state <= WALKING_RIGHT;
                        end
                    end
                    fall_counter <= 0;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 0;
                end
            end
            SPLATTERED: begin
                // Stay in this state forever
            end
        endcase
    end
end

always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
        end
        WALKING_LEFT: begin
            walk_left = 1;
        end
        WALKING_RIGHT: begin
            walk_right = 1;
        end
        FALLING: begin
            aaah = 1;
        end
        DIGGING: begin
            digging = 1;
        end
        SPLATTERED: begin
            // No outputs
        end
    endcase
end

endmodule