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

    // State encoding
    typedef enum {
        walking_left,
        walking_right,
        falling,
        digging,
        splattered,
        digging_falling,
        falling_from_digging
    } state_type;

    state_type state, next_state;
    reg [4:0] fall_counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= walking_left;
            fall_counter <= 0;
        end
        else begin
            state <= next_state;
            if (next_state == falling || next_state == falling_from_digging || next_state == digging_falling) begin
                fall_counter <= fall_counter + 1;
            end
            else begin
                fall_counter <= 0;
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
            walking_left: begin
                if (!ground) begin
                    next_state = falling;
                end
                else if (dig) begin
                    next_state = digging;
                end
                else if (bump_right) begin
                    next_state = walking_right;
                end
                else if (bump_left) begin
                    next_state = walking_right;
                end
                walk_left = 1;
            end
            walking_right: begin
                if (!ground) begin
                    next_state = falling;
                end
                else if (dig) begin
                    next_state = digging;
                end
                else if (bump_right) begin
                    next_state = walking_left;
                end
                else if (bump_left) begin
                    next_state = walking_left;
                end
                walk_right = 1;
            end
            falling: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = splattered;
                    end
                    else begin
                        next_state = walking_left;
                    end
                end
                aaah = 1;
            end
            digging: begin
                if (!ground) begin
                    next_state = falling_from_digging;
                end
                digging = 1;
            end
            falling_from_digging: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = splattered;
                    end
                    else begin
                        next_state = walking_left;
                    end
                end
                aaah = 1;
            end
            digging_falling: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = splattered;
                    end
                    else begin
                        next_state = walking_right;
                    end
                end
                aaah = 1;
            end
            splattered: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule