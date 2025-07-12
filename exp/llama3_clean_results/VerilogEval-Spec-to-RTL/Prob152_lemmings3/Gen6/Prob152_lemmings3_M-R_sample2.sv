module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig_in,
    output reg walk_left_out,
    output reg walk_right_out,
    output reg aaah,
    output reg digging
);

// Define states
`define S_WALK_LEFT 2'b00
`define S_WALK_RIGHT 2'b01
`define S_FALL 2'b10
`define S_DIG 2'b11

reg [1:0] state, next_state;
reg [1:0] prev_direction;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `S_WALK_LEFT;
        prev_direction <= `S_WALK_LEFT;
    end else begin
        state <= next_state;
        prev_direction <= (state == `S_FALL || state == `S_DIG)? prev_direction : (walk_left_out? `S_WALK_LEFT : `S_WALK_RIGHT);
    end
end

// Next state logic
always @(*) begin
    case (state)
        `S_WALK_LEFT: begin
            if (!ground) begin
                next_state <= `S_FALL;
            end else if (dig_in) begin
                next_state <= `S_DIG;
            end else if (bump_left) begin
                next_state <= `S_WALK_RIGHT;
            end else begin
                next_state <= `S_WALK_LEFT;
            end
        end
        `S_WALK_RIGHT: begin
            if (!ground) begin
                next_state <= `S_FALL;
            end else if (dig_in) begin
                next_state <= `S_DIG;
            end else if (bump_right) begin
                next_state <= `S_WALK_LEFT;
            end else begin
                next_state <= `S_WALK_RIGHT;
            end
        end
        `S_FALL: begin
            if (ground) begin
                next_state <= prev_direction;
            end else begin
                next_state <= `S_FALL;
            end
        end
        `S_DIG: begin
            if (!ground) begin
                next_state <= `S_FALL;
            end else begin
                next_state <= `S_DIG;
            end
        end
    endcase
end

// Output logic
assign walk_left_out = (state == `S_WALK_LEFT);
assign walk_right_out = (state == `S_WALK_RIGHT);
assign aaah = (state == `S_FALL);
assign digging = (state == `S_DIG);

endmodule