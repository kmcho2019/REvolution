module TopModule (
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

    // Enum for states
    enum logic [2:0] {
        IDLE_LEFT = 3'b001,
        IDLE_RIGHT = 3'b010,
        FALLING = 3'b011,
        DIGGING = 3'b100,
        SPLATTERED = 3'b101
    } state, next_state;

    // Counter for falling
    logic [5:0] fall_counter;

    // Counter for remembering original walking direction
    logic original_direction;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE_LEFT;
            fall_counter <= 6'b0;
            original_direction <= 1'b0;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end else begin
            case (state)
                IDLE_LEFT: begin
                    if (bump_left) begin
                        state <= IDLE_RIGHT;
                    end else if (bump_right) begin
                        state <= IDLE_LEFT;
                    end else if (dig && ground) begin
                        state <= DIGGING;
                        original_direction <= 1'b0;
                    end else if (!ground) begin
                        state <= FALLING;
                    end else begin
                        state <= IDLE_LEFT;
                    end
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
                IDLE_RIGHT: begin
                    if (bump_right) begin
                        state <= IDLE_LEFT;
                    end else if (bump_left) begin
                        state <= IDLE_RIGHT;
                    end else if (dig && ground) begin
                        state <= DIGGING;
                        original_direction <= 1'b1;
                    end else if (!ground) begin
                        state <= FALLING;
                    end else begin
                        state <= IDLE_RIGHT;
                    end
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
                FALLING: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            state <= SPLATTERED;
                        end else if (original_direction) begin
                            state <= IDLE_RIGHT;
                        end else begin
                            state <= IDLE_LEFT;
                        end
                    end else begin
                        state <= FALLING;
                        fall_counter <= fall_counter + 1;
                    end
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
                DIGGING: begin
                    if (!ground) begin
                        state <= FALLING;
                        original_direction <= original_direction;
                    end else begin
                        state <= DIGGING;
                    end
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end
                SPLATTERED: begin
                    state <= SPLATTERED;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
                default: begin
                    state <= IDLE_LEFT;
                end
            endcase
        end
    end

endmodule