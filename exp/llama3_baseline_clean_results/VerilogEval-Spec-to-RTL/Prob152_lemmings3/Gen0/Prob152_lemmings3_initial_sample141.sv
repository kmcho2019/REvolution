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

// Define the states
enum {WALKING_LEFT, WALKING_RIGHT, FALLING, DIGGING} state, nextState;

// Define the walking direction
reg walking_left_dir, walking_right_dir;

always @(*) begin
    // Default values
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    // Next state logic
    case (state)
        WALKING_LEFT: begin
            if (~ground) begin
                nextState = FALLING;
            end else if (dig) begin
                nextState = DIGGING;
            end else if (bump_left) begin
                nextState = WALKING_RIGHT;
            end else if (bump_right) begin
                nextState = WALKING_LEFT;
            end else begin
                nextState = WALKING_LEFT;
            end
            walk_left = 1;
        end
        WALKING_RIGHT: begin
            if (~ground) begin
                nextState = FALLING;
            end else if (dig) begin
                nextState = DIGGING;
            end else if (bump_left) begin
                nextState = WALKING_LEFT;
            end else if (bump_right) begin
                nextState = WALKING_RIGHT;
            end else begin
                nextState = WALKING_RIGHT;
            end
            walk_right = 1;
        end
        FALLING: begin
            if (ground) begin
                nextState = walking_left_dir ? WALKING_LEFT : WALKING_RIGHT;
            end else begin
                nextState = FALLING;
            end
            aaah = 1;
        end
        DIGGING: begin
            if (~ground) begin
                nextState = FALLING;
            end else begin
                nextState = DIGGING;
            end
            digging = 1;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = WALKING_LEFT;
        walking_left_dir = 1'b1;
        walking_right_dir = 1'b0;
    end else begin
        state = nextState;
        if (nextState == WALKING_LEFT) begin
            walking_left_dir = 1'b1;
            walking_right_dir = 1'b0;
        end else if (nextState == WALKING_RIGHT) begin
            walking_left_dir = 1'b0;
            walking_right_dir = 1'b1;
        end
    end
end

endmodule