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

reg [2:0] state;
reg [5:0] fall_counter;
reg direction;  // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b001;  // walk left
        fall_counter <= 0;
        direction <= 0;  // left
    end else begin
        case (state)
            3'b001: begin  // walk left
                if (!ground) begin
                    state <= 3'b010;  // fall
                    fall_counter <= 1;
                end else if (dig && !bump_left && !bump_right) begin
                    state <= 3'b011;  // dig
                end else if (bump_left) begin
                    state <= 3'b001;
                    direction <= 1;  // right
                end else if (bump_right) begin
                    state <= 3'b001;
                    direction <= 0;  // left
                end
            end
            3'b010: begin  // walk right
                if (!ground) begin
                    state <= 3'b010;  // fall
                    fall_counter <= 1;
                end else if (dig && !bump_left && !bump_right) begin
                    state <= 3'b011;  // dig
                end else if (bump_left) begin
                    state <= 3'b010;
                    direction <= 1;  // right
                end else if (bump_right) begin
                    state <= 3'b010;
                    direction <= 0;  // left
                end
            end
            3'b011: begin  // dig
                if (!ground) begin
                    state <= 3'b010;  // fall
                    fall_counter <= 1;
                end else if (!dig) begin
                    state <= 3'b001;  // walk left
                end
            end
            3'b100: begin  // fall
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 3'b101;  // splattered
                    end else begin
                        state <= direction ? 3'b010 : 3'b001;
                    end
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            3'b101: begin  // splattered
                // do nothing
            end
        endcase
    end
end

always @(*) begin
    case (state)
        3'b001: begin  // walk left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        3'b010: begin  // walk right
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        3'b011: begin  // dig
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        3'b100: begin  // fall
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3'b101: begin  // splattered
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule