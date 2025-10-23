module TopModule(
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
enum logic [2:0] {
    WALKING_LEFT = 3'b001,
    WALKING_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

// Counter for falling
reg [5:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
    end
end

always @(*) begin
    // Default values
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALKING_LEFT: begin
            walk_left = 1;
            if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else if (bump_right) begin
                next_state = WALKING_LEFT;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else begin
                next_state = WALKING_LEFT;
            end
        end
        WALKING_RIGHT: begin
            walk_right = 1;
            if (bump_right) begin
                next_state = WALKING_LEFT;
            end else if (bump_left) begin
                next_state = WALKING_RIGHT;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else begin
                next_state = WALKING_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else if (state == FALLING) begin
                    if (dig) begin
                        next_state = WALKING_LEFT;
                    end else begin
                        next_state = WALKING_LEFT;
                    end
                end else begin
                    next_state = WALKING_LEFT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            digging = 1;
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

endmodule