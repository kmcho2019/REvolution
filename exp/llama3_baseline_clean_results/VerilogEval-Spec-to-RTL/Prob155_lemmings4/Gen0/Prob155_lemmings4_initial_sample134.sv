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

reg [2:0] state; // 0: walking left, 1: walking right, 2: digging, 3: falling, 4: splattered
reg [4:0] fall_counter; // counter to track the number of clock cycles the Lemming has been falling
reg direction; // 0: left, 1: right

parameter WALK_LEFT = 3'b000;
parameter WALK_RIGHT = 3'b001;
parameter DIGGING = 3'b010;
parameter FALLING = 3'b011;
parameter SPLATTERED = 3'b100;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
        direction <= 0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALK_RIGHT;
                    direction <= 1;
                end else if (bump_right) begin
                    // do nothing
                end else begin
                    // do nothing
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                    direction <= 0;
                end else if (bump_left) begin
                    // do nothing
                end else begin
                    // do nothing
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                end else begin
                    // do nothing
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= SPLATTERED;
                    end else begin
                        if (direction) begin
                            state <= WALK_RIGHT;
                        end else begin
                            state <= WALK_LEFT;
                        end
                    end
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            SPLATTERED: begin
                // do nothing
            end
        endcase
    end
end

always @ (*) begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        DIGGING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
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