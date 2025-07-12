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
reg was_walking_left;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        was_walking_left <= 1'b1;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // Walking Left
            if (bump_left) next_state = 2'b01;
            else if (~ground) next_state = 2'b10;
            else if (dig) next_state = 2'b11;
            else next_state = 2'b00;
            was_walking_left = 1'b1;
        end
        2'b01: begin // Walking Right
            if (bump_right) next_state = 2'b00;
            else if (~ground) next_state = 2'b10;
            else if (dig) next_state = 2'b11;
            else next_state = 2'b01;
            was_walking_left = 1'b0;
        end
        2'b10: begin // Falling
            if (ground) begin
                if (was_walking_left) next_state = 2'b00;
                else next_state = 2'b01;
            end else next_state = 2'b10;
        end
        2'b11: begin // Digging
            if (~ground) next_state = 2'b10;
            else next_state = 2'b11;
        end
        default: next_state = 2'b00;
    endcase
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