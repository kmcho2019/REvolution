module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Top-level state machine states
`define IDLE 2'b00
`define WALKING 2'b01
`define FALLING 2'b10
`define DIGGING 2'b11

// Walking sub-state machine states
`define WALK_LEFT 1'b0
`define WALK_RIGHT 1'b1

reg [1:0] top_state, next_top_state;
reg walk_direction, next_walk_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= `WALKING;
        walk_direction <= `WALK_LEFT;
    end else begin
        top_state <= next_top_state;
        walk_direction <= next_walk_direction;
    end
end

always @(*) begin
    case (top_state)
        `WALKING: begin
            if (!ground) begin
                next_top_state = `FALLING;
            end else if (dig) begin
                next_top_state = `DIGGING;
            end else begin
                next_top_state = `WALKING;
            end
            // Walking sub-state machine
            if (bump_left && walk_direction == `WALK_LEFT) begin
                next_walk_direction = `WALK_RIGHT;
            end else if (bump_right && walk_direction == `WALK_RIGHT) begin
                next_walk_direction = `WALK_LEFT;
            end else begin
                next_walk_direction = walk_direction;
            end
        end
        `FALLING: begin
            if (ground) begin
                next_top_state = `WALKING;
            end else begin
                next_top_state = `FALLING;
            end
            next_walk_direction = walk_direction;
        end
        `DIGGING: begin
            if (!ground) begin
                next_top_state = `FALLING;
            end else begin
                next_top_state = `DIGGING;
            end
            next_walk_direction = walk_direction;
        end
        default: begin
            next_top_state = `WALKING;
            next_walk_direction = `WALK_LEFT;
        end
    endcase
end

always @(*) begin
    case (top_state)
        `WALKING: begin
            walk_left = (walk_direction == `WALK_LEFT) ? 1'b1 : 1'b0;
            walk_right = (walk_direction == `WALK_RIGHT) ? 1'b1 : 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        `FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        `DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule