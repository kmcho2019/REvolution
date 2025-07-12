module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
enum {IDLE_LEFT, IDLE_RIGHT, FALLING, TEMP_STATE} state, next_state;

// Define the temporary variables
reg temp_bump_left, temp_bump_right;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        temp_bump_left <= 1'b0;
        temp_bump_right <= 1'b0;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                    temp_bump_left <= bump_left;
                    temp_bump_right <= bump_right;
                end else if (bump_left) begin
                    state <= IDLE_RIGHT;
                end else if (bump_right) begin
                    state <= IDLE_LEFT;
                end else begin
                    state <= IDLE_LEFT;
                end
            end
            IDLE_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                    temp_bump_left <= bump_left;
                    temp_bump_right <= bump_right;
                end else if (bump_right) begin
                    state <= IDLE_LEFT;
                end else if (bump_left) begin
                    state <= IDLE_RIGHT;
                end else begin
                    state <= IDLE_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (temp_bump_left && temp_bump_right) begin
                        if (state == IDLE_LEFT) begin
                            state <= IDLE_RIGHT;
                        end else begin
                            state <= IDLE_LEFT;
                        end
                    end else if (temp_bump_left) begin
                        state <= IDLE_RIGHT;
                    end else if (temp_bump_right) begin
                        state <= IDLE_LEFT;
                    end else begin
                        if (state == IDLE_LEFT) begin
                            state <= IDLE_LEFT;
                        end else begin
                            state <= IDLE_RIGHT;
                        end
                    end
                end else begin
                    state <= FALLING;
                end
            end
            TEMP_STATE: begin
                state <= IDLE_LEFT;
            end
            default: begin
                state <= IDLE_LEFT;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule