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

// Define the states of the state machine
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

// Counter to track the number of clock cycles the Lemming has been falling
logic [5:0] fall_counter;

// Current direction of the Lemming
logic walk_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_direction <= 1'b1; // Walking left initially
        fall_counter <= 6'b0;
    end else begin
        state <= next_state;
        if (state == FALLING && ground) begin
            if (fall_counter > 20) begin
                state <= SPLATTERED;
            end
            fall_counter <= 6'b0;
        end
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 6'b0;
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_state = WALK_RIGHT;
            end
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = walk_direction ? WALK_LEFT : WALK_RIGHT;
                end
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (~dig) begin
                next_state = walk_direction ? WALK_LEFT : WALK_RIGHT;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
        end
        FALLING: begin
            aaah = 1'b1;
        end
        DIGGING: begin
            digging = 1'b1;
        end
        SPLATTERED: begin
            // Do nothing, all outputs should be 0
        end
    endcase
    if (state == FALLING) begin
        walk_direction = walk_left ? 1'b1 : 1'b0;
    end
end

endmodule