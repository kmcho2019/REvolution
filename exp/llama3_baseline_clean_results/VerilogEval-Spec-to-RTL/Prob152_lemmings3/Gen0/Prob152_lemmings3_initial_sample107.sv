module TopModule(
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

reg [1:0] state; // 0: walking_left, 1: walking_right, 2: falling, 3: digging
reg [1:0] next_state;
reg walk_direction; // 0: left, 1: right
reg prev_walk_direction;

parameter walking_left = 2'b00;
parameter walking_right = 2'b01;
parameter falling = 2'b10;
parameter digging = 2'b11;

always @(*) begin
    case (state)
        walking_left: begin
            if (~ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging;
            end else if (bump_left) begin
                next_state = walking_right;
            end else begin
                next_state = walking_left;
            end
        end
        walking_right: begin
            if (~ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging;
            end else if (bump_right) begin
                next_state = walking_left;
            end else begin
                next_state = walking_right;
            end
        end
        falling: begin
            if (ground) begin
                if (prev_walk_direction) begin
                    next_state = walking_right;
                end else begin
                    next_state = walking_left;
                end
            end else begin
                next_state = falling;
            end
        end
        digging: begin
            if (~ground) begin
                next_state = falling;
            end else begin
                next_state = digging;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = walking_left;
        walk_direction = 0;
        prev_walk_direction = 0;
    end else begin
        state = next_state;
        if (state == falling) begin
            prev_walk_direction = walk_direction;
        end
        if (state == walking_left) begin
            walk_direction = 0;
        end else if (state == walking_right) begin
            walk_direction = 1;
        end
    end
end

assign walk_left = (state == walking_left);
assign walk_right = (state == walking_right);
assign aaah = (state == falling);
assign digging = (state == digging);

endmodule