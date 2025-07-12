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

enum logic [3:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

logic [5:0] fall_counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_counter <= 0;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (!ground) begin
                    next_state <= FALLING;
                end else if (bump_left) begin
                    next_state <= IDLE_RIGHT;
                end else if (bump_right) begin
                    next_state <= IDLE_LEFT;
                end else if (dig) begin
                    next_state <= DIGGING;
                end else begin
                    next_state <= IDLE_LEFT;
                end
            end
            IDLE_RIGHT: begin
                if (!ground) begin
                    next_state <= FALLING;
                end else if (bump_left) begin
                    next_state <= IDLE_LEFT;
                end else if (bump_right) begin
                    next_state <= IDLE_RIGHT;
                end else if (dig) begin
                    next_state <= DIGGING;
                end else begin
                    next_state <= IDLE_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state <= SPLATTERED;
                    end else begin
                        if (state == IDLE_LEFT) begin
                            next_state <= IDLE_LEFT;
                        end else begin
                            next_state <= IDLE_RIGHT;
                        end
                    end
                end else begin
                    next_state <= FALLING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state <= FALLING;
                end else begin
                    next_state <= DIGGING;
                end
            end
            SPLATTERED: begin
                next_state <= SPLATTERED;
            end
        endcase
        if (state != next_state) begin
            state <= next_state;
        end
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
    end
end

always_comb begin
    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        IDLE_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        DIGGING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
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