module TopModule (
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

// Define states
enum logic [1:0] {
    WALK_LEFT = 2'b00,
    WALK_RIGHT = 2'b01,
    FALLING = 2'b10,
    DIGGING = 2'b11
} state, next_state;

// Current walking direction
logic [1:0] direction;

// Output logic
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

// Next state logic
always_comb begin
    case (state)
        WALK_LEFT: begin
            if (!ground) next_state = FALLING;
            else if (bump_right || bump_left) next_state = WALK_RIGHT;
            else if (dig) next_state = DIGGING;
            else next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (!ground) next_state = FALLING;
            else if (bump_left || bump_right) next_state = WALK_LEFT;
            else if (dig) next_state = DIGGING;
            else next_state = WALK_RIGHT;
        end
        FALLING: begin
            if (ground) next_state = (direction == 2'b00) ? WALK_LEFT : WALK_RIGHT;
            else next_state = FALLING;
        end
        DIGGING: begin
            if (!ground) next_state = FALLING;
            else next_state = DIGGING;
        end
        default: next_state = WALK_LEFT;
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        direction <= 2'b00;
    end else begin
        state <= next_state;
        if (next_state == FALLING) direction <= (state == WALK_LEFT) ? 2'b00 : 2'b01;
        else if (next_state == WALK_LEFT) direction <= 2'b00;
        else if (next_state == WALK_RIGHT) direction <= 2'b01;
    end
end

endmodule