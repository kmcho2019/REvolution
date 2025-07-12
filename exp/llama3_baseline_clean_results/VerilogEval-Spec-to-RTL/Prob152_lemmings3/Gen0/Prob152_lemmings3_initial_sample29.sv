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

reg [2:0] state, next_state;

parameter idle_left = 3'b000;
parameter idle_right = 3'b001;
parameter falling = 3'b010;
parameter digging_left = 3'b100;
parameter digging_right = 3'b101;

always @(*) begin
    case (state)
        idle_left: begin
            if (ground == 0) begin
                next_state = falling;
            end else if (dig == 1) begin
                next_state = digging_left;
            end else if (bump_left == 1 || (bump_left == 1 && bump_right == 1)) begin
                next_state = idle_right;
            end else if (bump_right == 1) begin
                next_state = idle_right;
            end else begin
                next_state = idle_left;
            end
        end
        idle_right: begin
            if (ground == 0) begin
                next_state = falling;
            end else if (dig == 1) begin
                next_state = digging_right;
            end else if (bump_right == 1 || (bump_left == 1 && bump_right == 1)) begin
                next_state = idle_left;
            end else if (bump_left == 1) begin
                next_state = idle_left;
            end else begin
                next_state = idle_right;
            end
        end
        falling: begin
            if (ground == 1) begin
                if (state == falling) begin //if we were falling
                    if (dig == 0) begin
                        if (bump_left == 1 || (bump_left == 1 && bump_right == 1)) begin
                            next_state = idle_right;
                        end else if (bump_right == 1) begin
                            next_state = idle_left;
                        end else if (dig == 0) begin
                            next_state = idle_left;
                        end else begin
                            next_state = idle_left;
                        end
                    end else begin
                        if (bump_left == 1 || (bump_left == 1 && bump_right == 1)) begin
                            next_state = idle_right;
                        end else if (bump_right == 1) begin
                            next_state = idle_left;
                        end else if (dig == 0) begin
                            next_state = idle_left;
                        end else begin
                            next_state = idle_left;
                        end
                    end
                end else if (state == digging_left || state == digging_right) begin //if we were digging
                    if (bump_left == 1 || (bump_left == 1 && bump_right == 1)) begin
                        next_state = idle_right;
                    end else if (bump_right == 1) begin
                        next_state = idle_left;
                    end else if (dig == 0) begin
                        next_state = idle_left;
                    end else begin
                        next_state = idle_left;
                    end
                end else begin
                    next_state = idle_left;
                end
            end else begin
                next_state = falling;
            end
        end
        digging_left: begin
            if (ground == 0) begin
                next_state = falling;
            end else if (dig == 0) begin
                next_state = idle_left;
            end else begin
                next_state = digging_left;
            end
        end
        digging_right: begin
            if (ground == 0) begin
                next_state = falling;
            end else if (dig == 0) begin
                next_state = idle_right;
            end else begin
                next_state = digging_right;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= idle_left;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        idle_left: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        idle_right: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        falling: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        digging_left: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        digging_right: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end
endmodule