`define STATE_WALKING_LEFT 2'b00
`define STATE_WALKING_RIGHT 2'b01
`define STATE_FALLING 2'b10

module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] current_state;
reg [1:0] next_state;
reg previous_walk_direction;
reg [1:0] temp_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= `STATE_WALKING_LEFT;
        previous_walk_direction <= 0;
    end else begin
        current_state <= next_state;
        if (ground) begin
            if (current_state == `STATE_WALKING_LEFT) begin
                previous_walk_direction <= 0;
            end else if (current_state == `STATE_WALKING_RIGHT) begin
                previous_walk_direction <= 1;
            end
        end
    end
end

always @(*) begin
    case (current_state)
        `STATE_WALKING_LEFT: begin
            if (!ground) begin
                next_state = `STATE_FALLING;
            end else if (bump_left) begin
                next_state = `STATE_WALKING_RIGHT;
            end else if (bump_right) begin
                next_state = `STATE_WALKING_LEFT;
            end else begin
                next_state = `STATE_WALKING_LEFT;
            end
        end
        `STATE_WALKING_RIGHT: begin
            if (!ground) begin
                next_state = `STATE_FALLING;
            end else if (bump_left) begin
                next_state = `STATE_WALKING_LEFT;
            end else if (bump_right) begin
                next_state = `STATE_WALKING_RIGHT;
            end else begin
                next_state = `STATE_WALKING_RIGHT;
            end
        end
        `STATE_FALLING: begin
            if (ground) begin
                if (previous_walk_direction) begin
                    next_state = `STATE_WALKING_RIGHT;
                end else begin
                    next_state = `STATE_WALKING_LEFT;
                end
            end else begin
                next_state = `STATE_FALLING;
            end
        end
        default: next_state = `STATE_WALKING_LEFT;
    endcase
end

always @(*) begin
    case (current_state)
        `STATE_WALKING_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        `STATE_WALKING_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        `STATE_FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
        default: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
    endcase
end

endmodule