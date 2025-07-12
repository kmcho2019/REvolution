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
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING_LEFT = 3'b100,
    DIGGING_RIGHT = 3'b101
} state, next_state;

// Combinational logic for next state
always_comb begin
    case(state)
        WALK_LEFT: begin
            if(!ground) next_state = FALLING;
            else if(dig) next_state = DIGGING_LEFT;
            else if(bump_right) next_state = WALK_RIGHT;
            else next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if(!ground) next_state = FALLING;
            else if(dig) next_state = DIGGING_RIGHT;
            else if(bump_left) next_state = WALK_LEFT;
            else next_state = WALK_RIGHT;
        end
        FALLING: begin
            if(ground) begin
                if(bump_left || bump_right) next_state = WALK_LEFT; // Both bump_left and bump_right are high
                else if(state == WALK_LEFT) next_state = WALK_LEFT;
                else if(state == WALK_RIGHT) next_state = WALK_RIGHT;
                else if(state == DIGGING_LEFT) next_state = WALK_LEFT;
                else if(state == DIGGING_RIGHT) next_state = WALK_RIGHT;
            end
            else next_state = FALLING;
        end
        DIGGING_LEFT: begin
            if(!ground) next_state = FALLING;
            else next_state = DIGGING_LEFT;
        end
        DIGGING_RIGHT: begin
            if(!ground) next_state = FALLING;
            else next_state = DIGGING_RIGHT;
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Sequential logic for state
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= WALK_LEFT;
    else state <= next_state;
end

// Output logic
always_comb begin
    case(state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING_LEFT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        DIGGING_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule