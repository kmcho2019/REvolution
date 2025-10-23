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

// Define states
enum logic [2:0] {
    IDLE = 3'b000,
    WALKING = 3'b001,
    DIGGING = 3'b010,
    FALLING = 3'b011,
    SPLATTERED = 3'b100
} state, next_state;

// Define sub-states for WALKING
enum logic {
    WALK_LEFT_SUB = 1'b0,
    WALK_RIGHT_SUB = 1'b1
} walking_sub_state, next_walking_sub_state;

// Define variables
reg [4:0] fall_counter;
reg direction; // 0 for left, 1 for right
reg next_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        walking_sub_state <= WALK_LEFT_SUB;
        fall_counter <= 5'b0;
        direction <= 1'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (ground) begin
                    state <= WALKING;
                    walking_sub_state <= WALK_LEFT_SUB;
                end
            end
            WALKING: begin
                if (dig && ground) begin
                    state <= DIGGING;
                end else if (~ground) begin
                    state <= FALLING;
                    fall_counter <= 5'b1;
                end else if (bump_left && bump_right) begin
                    next_direction = ~direction;
                end else if (bump_left) begin
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    next_direction = 1'b0;
                end else begin
                    next_direction = direction;
                end
                if (next_direction != direction) begin
                    direction <= next_direction;
                    if (direction) begin
                        walking_sub_state <= WALK_RIGHT_SUB;
                    end else begin
                        walking_sub_state <= WALK_LEFT_SUB;
                    end
                end
                if (walking_sub_state == WALK_LEFT_SUB) begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end else begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end
            end
            DIGGING: begin
                digging <= 1'b1;
                if (~ground) begin
                    state <= FALLING;
                    fall_counter <= 5'b1;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                aaah <= 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                        if (direction) begin
                            walking_sub_state <= WALK_RIGHT_SUB;
                        end else begin
                            walking_sub_state <= WALK_LEFT_SUB;
                        end
                    end
                    fall_counter <= 5'b0;
                end
            end
            SPLATTERED: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule