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

// Define the actions
`define ACTION_WALK 2'b00
`define ACTION_FALL 2'b01
`define ACTION_DIG 2'b10

// Define the directions
`define DIR_LEFT 1'b0
`define DIR_RIGHT 1'b1

// Action register
reg [1:0] action;
reg direction;

// Action controller
always @(posedge clk or posedge areset) begin
    if (areset) begin
        action <= `ACTION_WALK;
        direction <= `DIR_LEFT;
    end else begin
        case (action)
            `ACTION_WALK: begin
                if (!ground) begin
                    action <= `ACTION_FALL;
                end else if (dig) begin
                    action <= `ACTION_DIG;
                end else if (bump_left && (direction == `DIR_LEFT)) begin
                    direction <= `DIR_RIGHT;
                end else if (bump_right && (direction == `DIR_RIGHT)) begin
                    direction <= `DIR_LEFT;
                end
            end
            `ACTION_FALL: begin
                if (ground) begin
                    action <= `ACTION_WALK;
                end
            end
            `ACTION_DIG: begin
                if (!ground) begin
                    action <= `ACTION_FALL;
                end
            end
        endcase
    end
end

// Output generator
always @(*) begin
    case (action)
        `ACTION_WALK: begin
            walk_left = (direction == `DIR_LEFT);
            walk_right = (direction == `DIR_RIGHT);
            aaah = 1'b0;
            digging = 1'b0;
        end
        `ACTION_FALL: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        `ACTION_DIG: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end

endmodule