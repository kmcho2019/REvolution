`define walk_left 2'b01
`define walk_right 2'b10
`define fall 2'b11
`define dig 2'b00

module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left_out,
    output reg walk_right_out,
    output reg aaah,
    output reg digging
);

reg [1:0] state, next_state;
reg [1:0] prev_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `walk_left;
        prev_direction <= `walk_left;
    end else begin
        state <= next_state;
        prev_direction <= (state == `fall || state == `dig) ? prev_direction : (walk_left_out ? `walk_left : `walk_right);
    end
end

always @(*) begin
    case (state)
        `walk_left: begin
            if (!ground) begin
                next_state <= `fall;
            end else if (dig) begin
                next_state <= `dig;
            end else if (bump_left) begin
                next_state <= `walk_right;
            end else begin
                next_state <= `walk_left;
            end
        end
        `walk_right: begin
            if (!ground) begin
                next_state <= `fall;
            end else if (dig) begin
                next_state <= `dig;
            end else if (bump_right) begin
                next_state <= `walk_left;
            end else begin
                next_state <= `walk_right;
            end
        end
        `fall: begin
            if (ground) begin
                next_state <= prev_direction;
            end else begin
                next_state <= `fall;
            end
        end
        `dig: begin
            if (!ground) begin
                next_state <= `fall;
            end else begin
                next_state <= `dig;
            end
        end
    endcase
end

always @(*) begin
    case (state)
        `walk_left: begin
            walk_left_out <= 1;
            walk_right_out <= 0;
            aaah <= 0;
            digging <= 0;
        end
        `walk_right: begin
            walk_left_out <= 0;
            walk_right_out <= 1;
            aaah <= 0;
            digging <= 0;
        end
        `fall: begin
            walk_left_out <= 0;
            walk_right_out <= 0;
            aaah <= 1;
            digging <= 0;
        end
        `dig: begin
            walk_left_out <= 0;
            walk_right_out <= 0;
            aaah <= 0;
            digging <= 1;
        end
    endcase
end

endmodule