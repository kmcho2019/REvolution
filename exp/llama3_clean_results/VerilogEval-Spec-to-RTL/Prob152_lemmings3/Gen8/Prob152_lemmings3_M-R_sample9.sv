`define STATE_WALK 2'b00
`define STATE_FALL 2'b01
`define STATE_DIG 2'b10

`define DIR_LEFT 1'b0
`define DIR_RIGHT 1'b1

module TopModule (
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

reg [1:0] state;
reg [0:0] direction;

// Combinational logic for next state and direction
always_comb begin
    reg [1:0] next_state;
    reg [0:0] next_direction;
    
    case (state)
        `STATE_WALK: begin
            next_state = `STATE_WALK;
            next_direction = direction;
            if (!ground) begin
                next_state = `STATE_FALL;
            end else if (dig) begin
                next_state = `STATE_DIG;
            end else if (bump_left && (direction == `DIR_LEFT)) begin
                next_direction = `DIR_RIGHT;
            end else if (bump_right && (direction == `DIR_RIGHT)) begin
                next_direction = `DIR_LEFT;
            end
        end
        `STATE_FALL: begin
            next_state = `STATE_FALL;
            next_direction = direction;
            if (ground) begin
                next_state = `STATE_WALK;
            end
        end
        `STATE_DIG: begin
            next_state = `STATE_DIG;
            next_direction = direction;
            if (!ground) begin
                next_state = `STATE_FALL;
            end
        end
    endcase
    
    // Update state and direction
    if (areset) begin
        state <= `STATE_WALK;
        direction <= `DIR_LEFT;
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

// Output logic using assign
assign walk_left = (state == `STATE_WALK) && (direction == `DIR_LEFT);
assign walk_right = (state == `STATE_WALK) && (direction == `DIR_RIGHT);
assign aaah = (state == `STATE_FALL);
assign digging = (state == `STATE_DIG);

endmodule