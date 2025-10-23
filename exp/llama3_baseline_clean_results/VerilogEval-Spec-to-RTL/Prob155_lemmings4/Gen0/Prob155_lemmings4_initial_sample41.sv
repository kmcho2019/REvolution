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

// Enum for states
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALL = 3'b011,
    DIG = 3'b100,
    SPLAT = 3'b000
} state, next_state;

// Variables to keep track of direction and fall count
logic [1:0] direction; // 0: left, 1: right
logic [4:0] fall_count;

// Output logic
always_comb begin
    walk_left = (state == WALK_LEFT) ? 1'b1 : 1'b0;
    walk_right = (state == WALK_RIGHT) ? 1'b1 : 1'b0;
    aaah = (state == FALL) ? 1'b1 : 1'b0;
    digging = (state == DIG) ? 1'b1 : 1'b0;
end

// Next state logic
always_comb begin
    next_state = state;

    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
        end
        FALL: begin
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLAT;
                end else begin
                    next_state = (direction == 0) ? WALK_LEFT : WALK_RIGHT;
                end
            end
        end
        DIG: begin
            if (!ground) begin
                next_state = FALL;
            end
        end
        default: begin
            next_state = SPLAT;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        direction <= 0;
        fall_count <= 0;
    end else begin
        state <= next_state;

        case (state)
            FALL: begin
                fall_count <= fall_count + 1;
            end
            default: begin
                fall_count <= 0;
            end
        endcase

        case (next_state)
            WALK_RIGHT: begin
                direction <= 1;
            end
            WALK_LEFT: begin
                direction <= 0;
            end
            default: begin
                // No change
            end
        endcase
    end
end

endmodule