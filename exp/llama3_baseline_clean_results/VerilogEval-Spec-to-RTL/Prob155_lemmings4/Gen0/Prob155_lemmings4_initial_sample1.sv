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

reg [2:0] state; // WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, SPLATTERED
reg [2:0] next_state;
reg [5:0] fall_counter; // counter for number of clock cycles Lemming has been falling
reg [5:0] next_fall_counter;
reg walk_direction; // 1 for right, 0 for left

// state encoding
parameter WALK_LEFT = 3'b001;
parameter WALK_RIGHT = 3'b010;
parameter FALLING = 3'b011;
parameter DIGGING = 3'b100;
parameter SPLATTERED = 3'b111;

always @(*) begin
    // default values
    next_state = state;
    next_fall_counter = fall_counter;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case(state)
        WALK_LEFT: begin
            walk_left = 1;
            if (bump_right) begin
                next_state = WALK_RIGHT;
                walk_direction = 1;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
                walk_direction = 0;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end

        WALK_RIGHT: begin
            walk_right = 1;
            if (bump_left) begin
                next_state = WALK_LEFT;
                walk_direction = 0;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
                walk_direction = 1;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end

        FALLING: begin
            aaah = 1;
            next_fall_counter = fall_counter + 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = walk_direction ? WALK_RIGHT : WALK_LEFT;
                end
            end
        end

        DIGGING: begin
            digging = 1;
            if (!ground) begin
                next_state = FALLING;
            end
        end

        SPLATTERED: begin
            // do nothing
        end

        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
        walk_direction <= 0;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
    end
end

endmodule