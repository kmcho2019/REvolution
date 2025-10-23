module TopModule(
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
typedef enum logic [1:0] {
    WALKING_LEFT,
    WALKING_RIGHT,
    FALLING,
    DIGGING
} state_t;

// Define the current state and direction
reg [1:0] current_state;
reg direction;  // 0: left, 1: right

// Initialize the current state and direction
initial current_state = WALKING_LEFT;
initial direction = 0;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALKING_LEFT;
        direction <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (current_state)
            WALKING_LEFT: begin
                if (~ground) begin
                    current_state <= FALLING;
                    aaah <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 0;
                end else if (dig) begin
                    current_state <= DIGGING;
                    digging <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                end else if (bump_left) begin
                    direction <= 1;
                    current_state <= WALKING_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_right) begin
                    // do nothing, keep walking left
                end
            end
            WALKING_RIGHT: begin
                if (~ground) begin
                    current_state <= FALLING;
                    aaah <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 0;
                end else if (dig) begin
                    current_state <= DIGGING;
                    digging <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                end else if (bump_left) begin
                    direction <= 0;
                    current_state <= WALKING_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_right) begin
                    // do nothing, keep walking right
                end
            end
            FALLING: begin
                if (ground) begin
                    if (direction == 0) begin
                        current_state <= WALKING_LEFT;
                        walk_left <= 1;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        current_state <= WALKING_RIGHT;
                        walk_left <= 0;
                        walk_right <= 1;
                        aaah <= 0;
                        digging <= 0;
                    end
                end
            end
            DIGGING: begin
                if (~ground) begin
                    current_state <= FALLING;
                    aaah <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 0;
                end
            end
        endcase
    end
end

endmodule