module TopModule(
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

// State encoding
parameter walking_left = 2'b00;
parameter walking_right = 2'b01;
parameter falling = 2'b10;
parameter digging_state = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;
reg walk_direction;  // 1: walk right, 0: walk left

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= walking_left;
        walk_direction <= 1'b0;
    end else begin
        current_state <= next_state;
        if (ground && !dig) begin
            walk_direction <= walk_direction;
        end else if ((bump_left && !bump_right) || (!bump_left && bump_right)) begin
            walk_direction <= ~walk_direction;
        end else if (bump_left && bump_right) begin
            walk_direction <= ~walk_direction;
        end
    end
end

// Combinational logic for next state and outputs
always @(*) begin
    case (current_state)
        walking_left: begin
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging_state;
            end else if (bump_left) begin
                next_state = walking_right;
            end else if (bump_right) begin
                next_state = walking_left;
            end else begin
                next_state = walking_left;
            end
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        walking_right: begin
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging_state;
            end else if (bump_left) begin
                next_state = walking_left;
            end else if (bump_right) begin
                next_state = walking_left;
            end else begin
                next_state = walking_right;
            end
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        falling: begin
            if (ground) begin
                if (walk_direction) begin
                    next_state = walking_right;
                end else begin
                    next_state = walking_left;
                end
            end else begin
                next_state = falling;
            end
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        digging_state: begin
            if (!ground) begin
                next_state = falling;
            end else begin
                next_state = digging_state;
            end
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end

assign walk_left = (current_state == walking_left) ? 1'b1 : 1'b0;
assign walk_right = (current_state == walking_right) ? 1'b1 : 1'b0;

endmodule