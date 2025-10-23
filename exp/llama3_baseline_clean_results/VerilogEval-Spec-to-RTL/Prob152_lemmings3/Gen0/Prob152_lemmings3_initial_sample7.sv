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

reg [1:0] state, next_state;
reg direction;

always @(*) begin
    case (state)
        2'b00: begin // WALK_LEFT
            if (bump_left) begin
                next_state = 2'b01;
                direction = 1'b1;
            end
            else if (bump_right) begin
                next_state = 2'b00;
            end
            else if (!ground) begin
                next_state = 2'b10;
            end
            else if (dig) begin
                next_state = 2'b11;
            end
            else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // WALK_RIGHT
            if (bump_right) begin
                next_state = 2'b00;
                direction = 1'b0;
            end
            else if (bump_left) begin
                next_state = 2'b01;
            end
            else if (!ground) begin
                next_state = 2'b10;
            end
            else if (dig) begin
                next_state = 2'b11;
            end
            else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // FALLING
            if (ground) begin
                if (direction) begin
                    next_state = 2'b01;
                end
                else begin
                    next_state = 2'b00;
                end
            end
            else begin
                next_state = 2'b10;
            end
        end
        2'b11: begin // DIGGING
            if (!ground) begin
                next_state = 2'b10;
            end
            else begin
                next_state = 2'b11;
            end
        end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        direction <= 1'b0;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b10: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        2'b11: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule