module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
parameter WALKING = 2'b00;
parameter FALLING = 2'b01;
parameter DIGGING = 2'b10;
parameter SPLATTERED = 2'b11;

// Define the direction
parameter LEFT = 1'b0;
parameter RIGHT = 1'b1;

reg [1:0] state, next_state;
reg direction, next_direction;
reg [5:0] fall_count, next_fall_count;

assign walk_left = (state == WALKING && direction == LEFT) || (state == DIGGING && direction == LEFT);
assign walk_right = (state == WALKING && direction == RIGHT) || (state == DIGGING && direction == RIGHT);
assign aaah = state == FALLING;
assign digging = state == DIGGING;

always @(*) begin
    next_state = state;
    next_direction = direction;
    next_fall_count = fall_count;

    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
                next_fall_count = 1;
            end
            else if (dig && ground) begin
                next_state = DIGGING;
            end
            else if (bump_left && bump_right) begin
                next_direction = ~direction;
            end
            else if (bump_left) begin
                next_direction = RIGHT;
            end
            else if (bump_right) begin
                next_direction = LEFT;
            end
        end

        FALLING: begin
            next_fall_count = fall_count + 1;
            if (ground) begin
                if (fall_count >= 20) begin
                    next_state = SPLATTERED;
                end
                else begin
                    next_state = WALKING;
                end
            end
        end

        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                next_fall_count = 1;
            end
        end

        SPLATTERED: begin
            // Do nothing
        end

    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        direction <= LEFT;
        fall_count <= 0;
    end
    else begin
        state <= next_state;
        direction <= next_direction;
        fall_count <= next_fall_count;
    end
end

endmodule