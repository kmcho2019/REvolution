// Define the states as an enum
`define STATE_WALK_LEFT 2'b00
`define STATE_WALK_RIGHT 2'b01
`define STATE_FALL 2'b10
`define STATE_DIG 2'b11

module TopModule (
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

// Internal state and direction signals
reg [1:0] state;
reg prev_direction;

// Output signals
assign walk_left = (state == `STATE_WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == `STATE_WALK_RIGHT) ? 1'b1 : 1'b0;
assign aaah = (state == `STATE_FALL) ? 1'b1 : 1'b0;
assign digging = (state == `STATE_DIG) ? 1'b1 : 1'b0;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `STATE_WALK_LEFT;
        prev_direction <= 1'b0; // 0 for left, 1 for right
    end else begin
        case (state)
            `STATE_WALK_LEFT: begin
                if (!ground) begin
                    state <= `STATE_FALL;
                end else if (dig) begin
                    state <= `STATE_DIG;
                end else if (bump_left) begin
                    state <= `STATE_WALK_RIGHT;
                    prev_direction <= 1'b1; // update previous direction
                end else if (bump_right) begin
                    // do nothing, stay walking left
                end
            end
            `STATE_WALK_RIGHT: begin
                if (!ground) begin
                    state <= `STATE_FALL;
                end else if (dig) begin
                    state <= `STATE_DIG;
                end else if (bump_left) begin
                    // do nothing, stay walking right
                end else if (bump_right) begin
                    state <= `STATE_WALK_LEFT;
                    prev_direction <= 1'b0; // update previous direction
                end
            end
            `STATE_FALL: begin
                if (ground) begin
                    if (prev_direction) begin
                        state <= `STATE_WALK_RIGHT;
                    end else begin
                        state <= `STATE_WALK_LEFT;
                    end
                end
            end
            `STATE_DIG: begin
                if (!ground) begin
                    state <= `STATE_FALL;
                end
            end
        endcase
    end
end

endmodule