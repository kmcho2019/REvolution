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

parameter WALK_LEFT = 4'd0;
parameter WALK_RIGHT = 4'd1;
parameter FALLING = 4'd2;
parameter DIGGING = 4'd3;
parameter SPLATTERED = 4'd4;

reg [3:0] state;
reg [3:0] next_state;
reg [1:0] direction; // 0: LEFT, 1: RIGHT
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
    end
end

always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    
    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else if (dig) begin
                next_state = DIGGING;
                next_fall_counter = 0;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                next_fall_counter = 0;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                next_fall_counter = 0;
            end else begin
                next_state = WALK_LEFT;
                next_fall_counter = 0;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else if (dig) begin
                next_state = DIGGING;
                next_fall_counter = 0;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
                next_fall_counter = 0;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                next_fall_counter = 0;
            end else begin
                next_state = WALK_RIGHT;
                next_fall_counter = 0;
            end
        end
        FALLING: begin
            aaah = 1;
            next_fall_counter = fall_counter + 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else if (direction == 0) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            digging = 1;
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else begin
                next_state = DIGGING;
                next_fall_counter = 0;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
            next_fall_counter = 0;
        end
    endcase
end

always @(*) begin
    if (state == WALK_LEFT) begin
        direction = 0;
    end else if (state == WALK_RIGHT) begin
        direction = 1;
    end
end

endmodule