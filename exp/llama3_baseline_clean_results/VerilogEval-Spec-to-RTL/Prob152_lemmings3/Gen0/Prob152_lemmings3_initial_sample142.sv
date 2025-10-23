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

reg [1:0] state; // 00: Walking left, 01: Walking right, 10: Falling, 11: Digging
reg [1:0] nextState;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking left
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // Walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            if (~ground) begin
                nextState = 2'b10; // Falling
            end else if (dig) begin
                nextState = 2'b11; // Digging
            end else if (bump_left) begin
                nextState = 2'b01; // Walking right
            end else if (bump_right) begin
                nextState = 2'b01; // Walking right
            end else begin
                nextState = 2'b00; // Stay walking left
            end
        end
        2'b01: begin // Walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            if (~ground) begin
                nextState = 2'b10; // Falling
            end else if (dig) begin
                nextState = 2'b11; // Digging
            end else if (bump_right) begin
                nextState = 2'b00; // Walking left
            end else if (bump_left) begin
                nextState = 2'b00; // Walking left
            end else begin
                nextState = 2'b01; // Stay walking right
            end
        end
        2'b10: begin // Falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
            if (ground) begin
                if (state == 2'b00) begin
                    nextState = 2'b00; // Walking left
                end else begin
                    nextState = 2'b01; // Walking right
                end
            end else begin
                nextState = 2'b10; // Stay falling
            end
        end
        2'b11: begin // Digging
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
            if (~ground) begin
                nextState = 2'b10; // Falling
            end else begin
                nextState = 2'b11; // Stay digging
            end
        end
        default: begin
            nextState = 2'b00; // Default to walking left
        end
    endcase
end

endmodule