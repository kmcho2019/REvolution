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

// Define the states of the FSM
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Define the counter for the falling time
logic [5:0] fall_counter;
logic [5:0] next_fall_counter;

// Define the direction of the Lemming
logic walk_direction;
logic next_walk_direction;

// Define the output signals
assign walk_left = walk_direction && (state == WALK_LEFT) && !(state == SPLATTERED);
assign walk_right = !walk_direction && (state == WALK_RIGHT) && !(state == SPLATTERED);
assign aaah = state == FALLING;
assign digging = state == DIGGING;

// Define the state machine logic
always_comb begin
    next_state = state;
    next_fall_counter = fall_counter;
    next_walk_direction = walk_direction;

    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else if (bump_left) begin
                next_walk_direction = 1;
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_walk_direction = 0;
                next_state = WALK_LEFT;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else if (bump_left) begin
                next_walk_direction = 0;
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_walk_direction = 1;
                next_state = WALK_RIGHT;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = walk_direction ? WALK_LEFT : WALK_RIGHT;
                end
            end else begin
                next_fall_counter = fall_counter + 1;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end
        end
        SPLATTERED: begin
            // No state transition
        end
    endcase
end

// Update the state and counter on the positive edge of the clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_direction <= 0;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
        walk_direction <= next_walk_direction;
    end
end

endmodule