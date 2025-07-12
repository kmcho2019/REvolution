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

reg [2:0] state; // idle_left, idle_right, falling, digging_left, digging_right, splattered
reg [4:0] fall_counter; // counter to keep track of the number of clock cycles the Lemming has been falling
reg dig_dir; // register to keep track of the original direction of the Lemming when it started digging

parameter IDLE_LEFT = 3'b001;
parameter IDLE_RIGHT = 3'b010;
parameter FALLING = 3'b011;
parameter DIGGING_LEFT = 3'b100;
parameter DIGGING_RIGHT = 3'b101;
parameter SPLATTERED = 3'b110;

always @ (posedge clk or posedge areset)
begin
    if (areset)
    begin
        state <= IDLE_LEFT;
        fall_counter <= 5'b0;
        dig_dir <= 1'b0;
    end
    else
    begin
        case (state)
            IDLE_LEFT:
            begin
                if (!ground)
                begin
                    state <= FALLING;
                    fall_counter <= 1'b1;
                end
                else if (dig)
                begin
                    state <= DIGGING_LEFT;
                    dig_dir <= 1'b0;
                end
                else if (bump_left)
                begin
                    state <= IDLE_RIGHT;
                end
                else if (bump_right)
                begin
                    state <= IDLE_LEFT;
                end
                else
                begin
                    state <= IDLE_LEFT;
                end
            end
            IDLE_RIGHT:
            begin
                if (!ground)
                begin
                    state <= FALLING;
                    fall_counter <= 1'b1;
                end
                else if (dig)
                begin
                    state <= DIGGING_RIGHT;
                    dig_dir <= 1'b1;
                end
                else if (bump_left)
                begin
                    state <= IDLE_LEFT;
                end
                else if (bump_right)
                begin
                    state <= IDLE_RIGHT;
                end
                else
                begin
                    state <= IDLE_RIGHT;
                end
            end
            FALLING:
            begin
                if (ground)
                begin
                    if (fall_counter > 5'd20)
                    begin
                        state <= SPLATTERED;
                    end
                    else if (dig_dir == 1'b0)
                    begin
                        state <= IDLE_LEFT;
                    end
                    else
                    begin
                        state <= IDLE_RIGHT;
                    end
                end
                else
                begin
                    fall_counter <= fall_counter + 1'b1;
                    state <= FALLING;
                end
            end
            DIGGING_LEFT:
            begin
                if (!ground)
                begin
                    state <= FALLING;
                    fall_counter <= 1'b1;
                end
                else
                begin
                    state <= DIGGING_LEFT;
                end
            end
            DIGGING_RIGHT:
            begin
                if (!ground)
                begin
                    state <= FALLING;
                    fall_counter <= 1'b1;
                end
                else
                begin
                    state <= DIGGING_RIGHT;
                end
            end
            SPLATTERED:
            begin
                state <= SPLATTERED;
            end
            default:
            begin
                state <= IDLE_LEFT;
            end
        endcase
    end
end

always @ (*)
begin
    case (state)
        IDLE_LEFT:
        begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        IDLE_RIGHT:
        begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING:
        begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING_LEFT:
        begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        DIGGING_RIGHT:
        begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b1;
        end
        SPLATTERED:
        begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        default:
        begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule