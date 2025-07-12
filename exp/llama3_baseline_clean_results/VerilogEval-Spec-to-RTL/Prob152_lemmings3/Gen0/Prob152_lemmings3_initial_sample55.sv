module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Enum for states
enum logic [1:0] {walking_left, walking_right, falling, digging} state, next_state;

// Combinational logic for next state
always_comb begin
    case (state)
        walking_left: begin
            if (!ground) next_state = falling;
            else if (dig) next_state = digging;
            else if (bump_right) next_state = walking_right;
            else if (bump_left) next_state = walking_right; // Since it's already walking left, it will switch to walking right
            else next_state = walking_left;
        end
        walking_right: begin
            if (!ground) next_state = falling;
            else if (dig) next_state = digging;
            else if (bump_left) next_state = walking_left;
            else if (bump_right) next_state = walking_left; // Since it's already walking right, it will switch to walking left
            else next_state = walking_right;
        end
        falling: begin
            if (ground) begin
                if (state == falling) next_state = walking_left;
                else if (state == digging) next_state = walking_right;
                else next_state = state;
            end else next_state = falling;
        end
        digging: begin
            if (!ground) next_state = falling;
            else next_state = digging;
        end
        default: next_state = walking_left; // Default state
    endcase
end

// Sequential logic for state
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= walking_left;
    else state <= next_state;
end

// Output logic
always_comb begin
    case (state)
        walking_left: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        walking_right: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        falling: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        digging: begin
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