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

// Define the states
enum logic [1:0] {
    IDLE_LEFT = 2'b00,
    IDLE_RIGHT = 2'b01,
    FALLING = 2'b10,
    DIGGING = 2'b11
} state, next_state;

// Define the direction of the Lemming
logic [1:0] direction;

always_comb begin
    // Default values
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            if (bump_left || bump_right) begin
                if (bump_left && !bump_right) begin
                    next_state = IDLE_RIGHT;
                end else if (!bump_left && bump_right) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1'b1;
            if (bump_left || bump_right) begin
                if (bump_left && !bump_right) begin
                    next_state = IDLE_LEFT;
                end else if (!bump_left && bump_right) begin
                    next_state = IDLE_RIGHT;
                end else begin
                    next_state = IDLE_LEFT;
                end
            end else if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (direction == 2'b00) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        direction <= 2'b00;
    end else begin
        state <= next_state;
        if (state == IDLE_LEFT) begin
            direction <= 2'b00;
        end else if (state == IDLE_RIGHT) begin
            direction <= 2'b01;
        end
    end
end

endmodule