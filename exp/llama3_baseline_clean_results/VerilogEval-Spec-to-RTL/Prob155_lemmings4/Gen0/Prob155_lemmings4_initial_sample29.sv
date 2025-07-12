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

reg [2:0] state;
reg [5:0] fall_counter;

parameter IDLE_LEFT = 3'b001;
parameter IDLE_RIGHT = 3'b010;
parameter FALLING = 3'b011;
parameter DIGGING_LEFT = 3'b100;
parameter DIGGING_RIGHT = 3'b101;
parameter SPLATTERED = 3'b110;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_counter <= 0;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (bump_left) begin
                    state <= IDLE_RIGHT;
                end else if (dig) begin
                    state <= DIGGING_LEFT;
                end
            end
            IDLE_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (bump_right) begin
                    state <= IDLE_LEFT;
                end else if (dig) begin
                    state <= DIGGING_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= SPLATTERED;
                    end else if (state == DIGGING_LEFT) begin
                        state <= IDLE_LEFT;
                    end else if (state == DIGGING_RIGHT) begin
                        state <= IDLE_RIGHT;
                    end else if (state == IDLE_LEFT) begin
                        state <= IDLE_LEFT;
                    end else if (state == IDLE_RIGHT) begin
                        state <= IDLE_RIGHT;
                    end
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            DIGGING_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                    fall_counter <= 0;
                end
            end
            DIGGING_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                    fall_counter <= 0;
                end
            end
            SPLATTERED: begin
                // Stay in this state forever
            end
            default: begin
                state <= IDLE_LEFT;
            end
        endcase
    end
end

always @(state) begin
    case (state)
        IDLE_LEFT: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        IDLE_RIGHT: begin
            walk_left <= 0;
            walk_right <= 1;
            aaah <= 0;
            digging <= 0;
        end
        FALLING: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
            digging <= 0;
        end
        DIGGING_LEFT: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end
        DIGGING_RIGHT: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end
        SPLATTERED: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        default: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
    endcase
end

endmodule