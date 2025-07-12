module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [1:0] state, next_state;

// State encoding:
// 00: WALK_LEFT
// 01: WALK_RIGHT
// 10: FALLING
// 11: DIGGING

always @(*) begin
    case (state)
        2'b00: begin // WALK_LEFT
            if (!ground) begin
                next_state = 2'b10; // FALLING
            end else if (dig) begin
                next_state = 2'b11; // DIGGING
            end else if (bump_left) begin
                next_state = 2'b01; // WALK_RIGHT
            end else if (bump_right) begin
                next_state = 2'b01; // WALK_RIGHT
            end else begin
                next_state = 2'b00; // WALK_LEFT
            end
        end
        2'b01: begin // WALK_RIGHT
            if (!ground) begin
                next_state = 2'b10; // FALLING
            end else if (dig) begin
                next_state = 2'b11; // DIGGING
            end else if (bump_right) begin
                next_state = 2'b00; // WALK_LEFT
            end else if (bump_left) begin
                next_state = 2'b00; // WALK_LEFT
            end else begin
                next_state = 2'b01; // WALK_RIGHT
            end
        end
        2'b10: begin // FALLING
            if (ground) begin
                if (state == 2'b00) begin
                    next_state = 2'b00; // WALK_LEFT
                end else begin
                    next_state = 2'b01; // WALK_RIGHT
                end
            end else begin
                next_state = 2'b10; // FALLING
            end
        end
        2'b11: begin // DIGGING
            if (!ground) begin
                next_state = 2'b10; // FALLING
            end else begin
                next_state = 2'b11; // DIGGING
            end
        end
        default: begin
            next_state = 2'b00; // WALK_LEFT
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALK_LEFT
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // WALK_LEFT
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin // WALK_RIGHT
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b10: begin // FALLING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        2'b11: begin // DIGGING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule