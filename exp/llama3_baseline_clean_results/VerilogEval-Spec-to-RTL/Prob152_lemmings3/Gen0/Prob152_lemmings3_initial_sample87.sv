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
parameter WALKING_LEFT = 2'b00;
parameter WALKING_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

reg [1:0] state;
reg [1:0] next_state;
reg direction; // 0 for left, 1 for right
reg next_direction;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= WALKING_LEFT;
        direction <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        state <= next_state;
        direction <= next_direction;
        if(next_state == WALKING_LEFT) begin
            walk_left <= 1;
            walk_right <= 0;
        end else if(next_state == WALKING_RIGHT) begin
            walk_left <= 0;
            walk_right <= 1;
        end else begin
            walk_left <= 0;
            walk_right <= 0;
        end
    end
end

always @(*) begin
    next_state = state;
    next_direction = direction;
    case(state)
        WALKING_LEFT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(dig) begin
                next_state = DIGGING;
            end else if(bump_left) begin
                next_state = WALKING_RIGHT;
                next_direction = 1;
            end else if(bump_right) begin
                // No need to change direction
            end
        end
        WALKING_RIGHT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(dig) begin
                next_state = DIGGING;
            end else if(bump_right) begin
                next_state = WALKING_LEFT;
                next_direction = 0;
            end else if(bump_left) begin
                // No need to change direction
            end
        end
        FALLING: begin
            if(ground) begin
                if(direction == 0) begin
                    next_state = WALKING_LEFT;
                end else begin
                    next_state = WALKING_RIGHT;
                end
            end
        end
        DIGGING: begin
            if(!ground) begin
                next_state = FALLING;
            end
        end
    endcase
    if(state == FALLING) begin
        aaah <= 1;
    end else begin
        aaah <= 0;
    end
    if(state == DIGGING) begin
        digging <= 1;
    end else begin
        digging <= 0;
    end
end

endmodule