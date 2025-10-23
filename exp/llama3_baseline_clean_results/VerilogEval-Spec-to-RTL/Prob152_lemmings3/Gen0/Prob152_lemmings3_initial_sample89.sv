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
parameter S_WALK_LEFT = 2'b00;
parameter S_WALK_RIGHT = 2'b01;
parameter S_DIGGING = 2'b10;
parameter S_FALLING = 2'b11;

// Define the current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Define the direction of the Lemming
reg walk_dir;

// Output logic
always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    
    case (current_state)
        S_WALK_LEFT: begin
            walk_left = 1;
            if (walk_dir == 0) begin
                walk_left = 1;
                walk_right = 0;
            end else begin
                walk_left = 0;
                walk_right = 1;
            end
        end
        S_WALK_RIGHT: begin
            walk_right = 1;
            if (walk_dir == 0) begin
                walk_left = 1;
                walk_right = 0;
            end else begin
                walk_left = 0;
                walk_right = 1;
            end
        end
        S_DIGGING: begin
            digging = 1;
            if (walk_dir == 0) begin
                walk_left = 1;
                walk_right = 0;
            end else begin
                walk_left = 0;
                walk_right = 1;
            end
        end
        S_FALLING: begin
            aaah = 1;
            walk_left = 0;
            walk_right = 0;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

// Next state logic
always @(*) begin
    case (current_state)
        S_WALK_LEFT: begin
            if (!ground) begin
                next_state = S_FALLING;
            end else if (dig && ground) begin
                next_state = S_DIGGING;
            end else if (bump_left) begin
                next_state = S_WALK_RIGHT;
                walk_dir = 1;
            end else if (bump_right) begin
                next_state = S_WALK_LEFT;
                walk_dir = 0;
            end else begin
                next_state = S_WALK_LEFT;
            end
        end
        S_WALK_RIGHT: begin
            if (!ground) begin
                next_state = S_FALLING;
            end else if (dig && ground) begin
                next_state = S_DIGGING;
            end else if (bump_left) begin
                next_state = S_WALK_LEFT;
                walk_dir = 0;
            end else if (bump_right) begin
                next_state = S_WALK_RIGHT;
                walk_dir = 1;
            end else begin
                next_state = S_WALK_RIGHT;
            end
        end
        S_DIGGING: begin
            if (!ground) begin
                next_state = S_FALLING;
            end else begin
                next_state = S_DIGGING;
            end
        end
        S_FALLING: begin
            if (ground) begin
                if (walk_dir == 0) begin
                    next_state = S_WALK_LEFT;
                end else begin
                    next_state = S_WALK_RIGHT;
                end
            end else begin
                next_state = S_FALLING;
            end
        end
        default: begin
            next_state = S_WALK_LEFT;
        end
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state = S_WALK_LEFT;
        walk_dir = 0;
    end else begin
        current_state = next_state;
    end
end

endmodule