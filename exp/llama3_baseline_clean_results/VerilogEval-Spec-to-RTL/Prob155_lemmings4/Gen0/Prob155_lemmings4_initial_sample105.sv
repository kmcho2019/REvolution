module TopModule (
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
    WALK_LEFT = 4'b0001,
    WALK_RIGHT = 4'b0010,
    FALLING = 4'b0011,
    DIGGING = 4'b0100,
    SPLATTERED = 4'b0101
} state, next_state;

// Define the number of clock cycles the Lemming has been falling
reg [5:0] fall_count;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_count <= fall_count + 1;
        end else begin
            fall_count <= 0;
        end
    end
end

always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
            walk_left = (state == WALK_LEFT);
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
            walk_left = 0;
            walk_right = (state == WALK_RIGHT);
            aaah = 0;
            digging = 0;
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = (state == FALLING && walk_left == 1) ? WALK_LEFT : WALK_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
            walk_left = 0;
            walk_right = 0;
            aaah = (state == FALLING);
            digging = 0;
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = (state == DIGGING);
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        default: begin
            next_state = WALK_LEFT;
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule