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
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

// Counter to track falling time
logic [5:0] fall_count;

// Default assignments for outputs
assign walk_left = 1'b0;
assign walk_right = 1'b0;
assign aaah = 1'b0;
assign digging = 1'b0;

// State machine logic
always_comb begin
    // Default next state is the current state
    next_state = state;
    
    case (state)
        WALK_LEFT: begin
            if (bump_left) next_state = WALK_RIGHT;
            else if (bump_right) next_state = WALK_LEFT; // No change
            else if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
        end
        WALK_RIGHT: begin
            if (bump_right) next_state = WALK_LEFT;
            else if (bump_left) next_state = WALK_RIGHT; // No change
            else if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 20) next_state = SPLATTERED;
                else if (state == WALK_LEFT) next_state = WALK_LEFT;
                else if (state == WALK_RIGHT) next_state = WALK_RIGHT;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: next_state = SPLATTERED; // Stay in this state
    endcase
end

// Sequential logic for state and fall count
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 6'b0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_count <= fall_count + 1'b1;
        end else begin
            fall_count <= 6'b0;
        end
    end
end

// Output logic
always_comb begin
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
        default: begin
            // SPLATTERED state: all outputs are 0
        end
    endcase
end

endmodule