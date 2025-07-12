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

// Define states
enum logic [2:0] {IDLE, WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Counters
reg [5:0] fall_count;
reg [5:0] dig_count;

// Determine next state
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (areset) next_state = WALK_LEFT;
        end
        WALK_LEFT: begin
            if (areset) next_state = IDLE;
            else if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else if (bump_left || bump_right) next_state = WALK_RIGHT;
        end
        WALK_RIGHT: begin
            if (areset) next_state = IDLE;
            else if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else if (bump_left || bump_right) next_state = WALK_LEFT;
        end
        FALLING: begin
            if (areset) next_state = IDLE;
            else if (ground) begin
                if (fall_count > 20) next_state = SPLATTERED;
                else if (state == FALLING && dig) next_state = DIGGING;
                else if (state == FALLING && bump_left) next_state = WALK_LEFT;
                else if (state == FALLING && bump_right) next_state = WALK_RIGHT;
                else if (state == FALLING) next_state = WALK_LEFT;
            end
        end
        DIGGING: begin
            if (areset) next_state = IDLE;
            else if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else next_state = WALK_LEFT;
        end
        SPLATTERED: begin
            if (areset) next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Update state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        fall_count <= 0;
        dig_count <= 0;
    end
    else begin
        state <= next_state;
        if (state == FALLING) fall_count <= fall_count + 1;
        else fall_count <= 0;
        if (state == DIGGING) dig_count <= dig_count + 1;
        else dig_count <= 0;
    end
end

// Determine outputs
always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case (state)
        WALK_LEFT: walk_left = 1;
        WALK_RIGHT: walk_right = 1;
        FALLING: aaah = 1;
        DIGGING: digging = 1;
        default: ;
    endcase
    if (state == SPLATTERED) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
    end
end

endmodule