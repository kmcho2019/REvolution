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

// State machine states
`define IDLE 2'b00
`define WALKING 2'b01
`define FALLING 2'b10

// Walking direction states
`define WALKING_LEFT 1'b0
`define WALKING_RIGHT 1'b1

reg [1:0] state, next_state;
reg [0:0] walking_direction, next_walking_direction;
reg digging_status, next_digging_status;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `IDLE;
        walking_direction <= `WALKING_LEFT;
        digging_status <= 1'b0;
    end else begin
        state <= next_state;
        walking_direction <= next_walking_direction;
        digging_status <= next_digging_status;
    end
end

// Next state logic
always @(*) begin
    case (state)
        `IDLE: begin
            if (ground) begin
                next_state <= `WALKING;
            end else begin
                next_state <= `IDLE;
            end
        end
        `WALKING: begin
            if (!ground) begin
                next_state <= `FALLING;
            end else if (dig) begin
                next_state <= `WALKING;
                next_digging_status <= 1'b1;
            end else begin
                next_state <= `WALKING;
            end
        end
        `FALLING: begin
            if (ground) begin
                next_state <= `WALKING;
            end else begin
                next_state <= `FALLING;
            end
        end
    endcase
end

// Next walking direction logic
always @(*) begin
    case (1'b1)
        1'b1: begin
            if ((bump_left && walking_direction == `WALKING_LEFT) || (bump_right && walking_direction == `WALKING_RIGHT)) begin
                next_walking_direction <= ~walking_direction;
            end else begin
                next_walking_direction <= walking_direction;
            end
        end
    endcase
end

// Next digging status logic
always @(*) begin
    case (1'b1)
        1'b1: begin
            if (state == `WALKING && dig) begin
                next_digging_status <= 1'b1;
            end else if (state != `WALKING || !dig) begin
                next_digging_status <= 1'b0;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        `IDLE: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        `WALKING: begin
            walk_left <= (walking_direction == `WALKING_LEFT)? 1'b1 : 1'b0;
            walk_right <= (walking_direction == `WALKING_RIGHT)? 1'b1 : 1'b0;
            aaah <= 1'b0;
            digging <= digging_status;
        end
        `FALLING: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
        end
    endcase
end

endmodule