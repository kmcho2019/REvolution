`timescale 1ns/1ps

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

parameter MAX_FALL_CYCLES = 20;

typedef enum logic [4:0] {
    walking_left,
    walking_right,
    falling,
    digging_left,
    digging_right,
    splattered
} state_type;

state_type current_state;
state_type next_state;
logic [4:0] fall_counter;
logic [4:0] next_fall_counter;

always @(*) begin
    next_state = current_state;
    next_fall_counter = fall_counter;
    
    case(current_state)
        walking_left: begin
            if (!ground) begin
                next_state = falling;
                next_fall_counter = 1;
            end else if (dig) begin
                next_state = digging_left;
            end else if (bump_left) begin
                next_state = walking_right;
            end else if (bump_right) begin
                next_state = walking_left;
            end else if (bump_left && bump_right) begin
                next_state = walking_right;
            end
        end
        walking_right: begin
            if (!ground) begin
                next_state = falling;
                next_fall_counter = 1;
            end else if (dig) begin
                next_state = digging_right;
            end else if (bump_left) begin
                next_state = walking_left;
            end else if (bump_right) begin
                next_state = walking_right;
            end else if (bump_left && bump_right) begin
                next_state = walking_left;
            end
        end
        falling: begin
            if (ground) begin
                if (fall_counter > MAX_FALL_CYCLES) begin
                    next_state = splattered;
                end else begin
                    next_state = current_state == digging_left ? walking_left : walking_right;
                end
                next_fall_counter = 0;
            end else begin
                next_fall_counter = fall_counter + 1;
            end
        end
        digging_left: begin
            if (!ground) begin
                next_state = falling;
                next_fall_counter = 1;
            end else begin
                next_state = walking_left;
            end
        end
        digging_right: begin
            if (!ground) begin
                next_state = falling;
                next_fall_counter = 1;
            end else begin
                next_state = walking_right;
            end
        end
        splattered: begin
            next_state = splattered;
        end
        default: begin
            next_state = walking_left;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= walking_left;
        fall_counter <= 0;
    end else begin
        current_state <= next_state;
        fall_counter <= next_fall_counter;
    end
end

always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    
    case(current_state)
        walking_left: begin
            walk_left = 1;
        end
        walking_right: begin
            walk_right = 1;
        end
        falling: begin
            aaah = 1;
        end
        digging_left: begin
            walk_left = 1;
            digging = 1;
        end
        digging_right: begin
            walk_right = 1;
            digging = 1;
        end
        splattered: begin
        end
        default: begin
            walk_left = 1;
        end
    endcase
end

endmodule