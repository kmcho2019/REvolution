module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states
enum logic [1:0] {WALK_LEFT = 2'b00, WALK_RIGHT = 2'b01, FALLING = 2'b10, DIGGING = 2'b11} state, next_state;

// Assign initial state
initial state = WALK_LEFT;

// Previous walking direction
reg prev_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT; // Reset to WALK_LEFT state
        prev_direction <= 1'b0;
    end else begin
        state <= next_state;
        if (state == FALLING || state == DIGGING) begin
            prev_direction <= (state == FALLING) ? prev_direction : (walk_left) ? 1'b0 : 1'b1;
        end else if (state == WALK_LEFT || state == WALK_RIGHT) begin
            prev_direction <= (state == WALK_LEFT) ? 1'b0 : 1'b1;
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (bump_left || bump_right) begin
                next_state = WALK_RIGHT;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (bump_left || bump_right) begin
                next_state = WALK_LEFT;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                next_state = (prev_direction == 1'b0) ? WALK_LEFT : WALK_RIGHT;
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

endmodule