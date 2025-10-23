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
`define walking 2'b01
`define falling 2'b10
`define digging 2'b11

// Walking sub-state machine states
`define walking_left 1'b0
`define walking_right 1'b1

reg [1:0] top_state, next_top_state;
reg walking_direction, next_walking_direction;
reg digging_status, next_digging_status;

// Top-level state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= `walking;
        walking_direction <= `walking_left;
        digging_status <= 1'b0;
    end else begin
        top_state <= next_top_state;
        walking_direction <= next_walking_direction;
        digging_status <= next_digging_status;
    end
end

// Top-level state machine combinational logic
always @(*) begin
    case (top_state)
        `walking: begin
            if (!ground) begin
                next_top_state <= `falling;
            end else if (dig) begin
                next_top_state <= `digging;
            end else begin
                next_top_state <= `walking;
            end
        end
        `falling: begin
            if (ground) begin
                next_top_state <= `walking;
            end else begin
                next_top_state <= `falling;
            end
        end
        `digging: begin
            if (!ground) begin
                next_top_state <= `falling;
            end else begin
                next_top_state <= `digging;
            end
        end
    endcase
end

// Walking sub-state machine combinational logic
always @(*) begin
    case (top_state)
        `walking: begin
            if (bump_left && walking_direction == `walking_left) begin
                next_walking_direction <= `walking_right;
            end else if (bump_right && walking_direction == `walking_right) begin
                next_walking_direction <= `walking_left;
            end else begin
                next_walking_direction <= walking_direction;
            end
        end
        default: begin
            next_walking_direction <= walking_direction;
        end
    endcase
end

// Digging sub-state machine combinational logic
always @(*) begin
    case (top_state)
        `digging: begin
            if (dig) begin
                next_digging_status <= 1'b1;
            end else begin
                next_digging_status <= digging_status;
            end
        end
        default: begin
            next_digging_status <= 1'b0;
        end
    endcase
end

// Output logic
always @(*) begin
    case (top_state)
        `walking: begin
            walk_left <= (walking_direction == `walking_left)? 1'b1 : 1'b0;
            walk_right <= (walking_direction == `walking_right)? 1'b1 : 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        `falling: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
        end
        `digging: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= digging_status;
        end
    endcase
end

endmodule