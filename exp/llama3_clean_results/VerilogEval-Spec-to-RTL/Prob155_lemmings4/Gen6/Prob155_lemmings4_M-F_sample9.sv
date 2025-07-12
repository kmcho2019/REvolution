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
enum logic [1:0] {
    IDLE = 2'b00,
    WALKING = 2'b01,
    FALLING = 2'b10,
    SPLATTERED = 2'b11
} state, next_state;

// Define sub-states for WALKING
enum logic [1:0] {
    WALK_LEFT_SUB = 2'b00,
    WALK_RIGHT_SUB = 2'b01,
    DIGGING_SUB = 2'b10
} walking_sub_state, next_walking_sub_state;

// Define sub-states for FALLING
enum logic [1:0] {
    COUNTING_SUB = 2'b00
} falling_sub_state, next_falling_sub_state;

// Define variables
reg [4:0] fall_counter;
reg direction; // 0 for left, 1 for right
reg is_digging;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        walking_sub_state <= WALK_LEFT_SUB;
        falling_sub_state <= COUNTING_SUB;
        fall_counter <= 5'b0;
        direction <= 1'b0;
        is_digging <= 1'b0;
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
                case (walking_sub_state)
                    WALK_LEFT_SUB: begin
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                        if (dig && ground) begin
                            walking_sub_state <= DIGGING_SUB;
                            is_digging <= 1'b1;
                        end else if (bump_right) begin
                            walking_sub_state <= WALK_RIGHT_SUB;
                            direction <= 1'b1;
                        end else if (bump_left) begin
                            walking_sub_state <= WALK_LEFT_SUB;
                            direction <= 1'b0;
                        end
                        if (~ground) begin
                            state <= FALLING;
                            falling_sub_state <= COUNTING_SUB;
                            fall_counter <= 5'b1;
                            is_digging <= 1'b0;
                        end
                    end
                    WALK_RIGHT_SUB: begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                        if (dig && ground) begin
                            walking_sub_state <= DIGGING_SUB;
                            is_digging <= 1'b1;
                        end else if (bump_left) begin
                            walking_sub_state <= WALK_LEFT_SUB;
                            direction <= 1'b0;
                        end else if (bump_right) begin
                            walking_sub_state <= WALK_RIGHT_SUB;
                            direction <= 1'b1;
                        end
                        if (~ground) begin
                            state <= FALLING;
                            falling_sub_state <= COUNTING_SUB;
                            fall_counter <= 5'b1;
                            is_digging <= 1'b0;
                        end
                    end
                    DIGGING_SUB: begin
                        digging <= 1'b1;
                        if (~ground) begin
                            state <= FALLING;
                            falling_sub_state <= COUNTING_SUB;
                            fall_counter <= 5'b1;
                            is_digging <= 1'b0;
                        end else if (~dig) begin
                            if (direction) begin
                                walking_sub_state <= WALK_RIGHT_SUB;
                            end else begin
                                walking_sub_state <= WALK_LEFT_SUB;
                            end
                            is_digging <= 1'b0;
                        end
                    end
                endcase
            end
            FALLING: begin
                case (falling_sub_state)
                    COUNTING_SUB: begin
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
                                is_digging <= 1'b0;
                                fall_counter <= 5'b0;
                            end
                        end
                    end
                endcase
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