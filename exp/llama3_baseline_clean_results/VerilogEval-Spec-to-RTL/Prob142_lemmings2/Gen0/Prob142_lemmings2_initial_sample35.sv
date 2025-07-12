module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state, next_state;
localparam walking_left = 2'b00;
localparam walking_right = 2'b01;
localparam falling = 2'b10;

always @(*) begin
    case (state)
        walking_left: begin
            if (bump_left) next_state = walking_right;
            else if (bump_right) next_state = walking_right;
            else if (!ground) next_state = falling;
            else next_state = walking_left;
        end
        walking_right: begin
            if (bump_right) next_state = walking_left;
            else if (bump_left) next_state = walking_left;
            else if (!ground) next_state = falling;
            else next_state = walking_right;
        end
        falling: begin
            if (ground) begin
                if (state == falling && (next_state == walking_left || next_state == walking_right)) begin
                    if (next_state == walking_left) next_state = walking_left;
                    else next_state = walking_right;
                end else begin
                    if (state == walking_left) next_state = walking_left;
                    else next_state = walking_right;
                end
            end else next_state = falling;
        end
        default: next_state = walking_left;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) state <= walking_left;
    else state <= next_state;
end

always @(state) begin
    case (state)
        walking_left: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        walking_right: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        falling: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
        end
    endcase
end

endmodule