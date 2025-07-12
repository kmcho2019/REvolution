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
enum logic [2:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Define the previous walking direction
logic [0:0] prev_walk_left;

// Define the counter for the number of clock cycles that the Lemming has been falling
logic [5:0] fall_count;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
        prev_walk_left <= 1;
    end
    else begin
        state <= next_state;
        if (state == FALLING) begin
            if (next_state == FALLING) begin
                fall_count <= fall_count + 1;
            end
            else begin
                fall_count <= 0;
            end
        end
        else begin
            fall_count <= 0;
        end
        if (next_state == WALK_LEFT) begin
            prev_walk_left <= 1;
        end
        else if (next_state == WALK_RIGHT) begin
            prev_walk_left <= 0;
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end
            else if (bump_right) begin
                // Do nothing
            end
            else if (!ground) begin
                next_state = FALLING;
            end
            else if (dig) begin
                next_state = DIGGING;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (bump_left) begin
                // Do nothing
            end
            else if (bump_right) begin
                next_state = WALK_LEFT;
            end
            else if (!ground) begin
                next_state = FALLING;
            end
            else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end
                else if (prev_walk_left) begin
                    next_state = WALK_LEFT;
                end
                else begin
                    next_state = WALK_RIGHT;
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
            // Do nothing
        end
    endcase
end

endmodule