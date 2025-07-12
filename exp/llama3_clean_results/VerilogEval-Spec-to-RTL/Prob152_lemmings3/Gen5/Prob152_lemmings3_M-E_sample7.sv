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
enum logic [1:0] {
    IDLE = 2'b00,
    WALKING = 2'b01,
    FALLING = 2'b10,
    DIGGING = 2'b11
} state, next_state;

// Define the walking states
enum logic [1:0] {
    WALK_LEFT = 2'b00,
    WALK_RIGHT = 2'b01
} walking_state, next_walking_state;

// Define the digging states
enum logic [1:0] {
    DIGGING_START = 2'b00,
    DIGGING_CONT = 2'b01
} digging_state, next_digging_state;

// Store the original direction before falling
reg [1:0] last_walking_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        walking_state <= WALK_LEFT;
        digging_state <= DIGGING_START;
    end else begin
        state <= next_state;
        walking_state <= next_walking_state;
        digging_state <= next_digging_state;
        if (next_state == FALLING) begin
            last_walking_direction <= walking_state;
        end
    end
end

// Combinational logic for next state
always_comb begin
    next_state = state;
    next_walking_state = walking_state;
    next_digging_state = digging_state;

    case (state)
        IDLE: begin
            if (ground) begin
                next_state = WALKING;
            end
        end
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                if (walking_state == WALK_LEFT) begin
                    next_walking_state = WALK_RIGHT;
                end else begin
                    next_walking_state = WALK_LEFT;
                end
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
                if (last_walking_direction == WALK_LEFT) begin
                    next_walking_state = WALK_LEFT;
                end else begin
                    next_walking_state = WALK_RIGHT;
                end
            end
        end
        DIGGING: begin
            case (digging_state)
                DIGGING_START: begin
                    next_digging_state = DIGGING_CONT;
                end
                DIGGING_CONT: begin
                    if (!ground) begin
                        next_state = FALLING;
                    end
                end
            endcase
        end
    endcase
end

// Combinational logic for outputs
always_comb begin
    walk_left = (state == WALKING && walking_state == WALK_LEFT);
    walk_right = (state == WALKING && walking_state == WALK_RIGHT);
    aaah = (state == FALLING);
    digging = (state == DIGGING);
end

endmodule