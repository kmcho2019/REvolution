`define STATE_ON_GROUND 1'b0
`define STATE_FALLING 1'b1

`define ACTION_WALK 2'b00
`define ACTION_DIG 2'b01
`define ACTION_FALL 2'b10

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

reg [1:0] action, next_action;
reg [0:0] state, next_state;
reg [0:0] direction, next_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `STATE_ON_GROUND;
        action <= `ACTION_WALK;
        direction <= 1'b0; // Initial direction: left
    end else begin
        state <= next_state;
        action <= next_action;
        direction <= next_direction;
    end
end

always_comb begin
    next_state = state;
    next_action = action;
    next_direction = direction;
    
    // State machine for overall state (on ground or falling)
    if (ground) begin
        next_state = `STATE_ON_GROUND;
    end else begin
        next_state = `STATE_FALLING;
    end
    
    // Action sub-state machine
    case (action)
        `ACTION_WALK: begin
            if (dig && state == `STATE_ON_GROUND) begin
                next_action = `ACTION_DIG;
            end else if (state == `STATE_FALLING) begin
                next_action = `ACTION_FALL;
            end
        end
        `ACTION_DIG: begin
            if (!ground) begin
                next_action = `ACTION_FALL;
            end
        end
        `ACTION_FALL: begin
            if (ground) begin
                next_action = `ACTION_WALK;
            end
        end
    endcase
    
    // Direction sub-state machine
    if (bump_left && direction == 1'b0) begin
        next_direction = 1'b1; // Switch to right
    end else if (bump_right && direction == 1'b1) begin
        next_direction = 1'b0; // Switch to left
    end
end

assign walk_left = (action == `ACTION_WALK && direction == 1'b0);
assign walk_right = (action == `ACTION_WALK && direction == 1'b1);
assign aaah = (action == `ACTION_FALL);
assign digging = (action == `ACTION_DIG);

endmodule