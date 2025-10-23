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

reg [1:0] state; // 0: walking, 1: falling, 2: digging
reg direction; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        direction <= 0;
    end else begin
        case (state)
            0: begin // walking
                if (!ground) begin
                    state <= 1;
                end else if (dig && ground) begin
                    state <= 2;
                end else if (bump_left && bump_right) begin
                    direction <= ~direction;
                end else if (bump_left) begin
                    direction <= 1;
                end else if (bump_right) begin
                    direction <= 0;
                end
            end
            1: begin // falling
                if (ground) begin
                    state <= 0;
                end
            end
            2: begin // digging
                if (!ground) begin
                    state <= 1;
                end
            end
        endcase
    end
end

always @(state, direction) begin
    case (state)
        0: begin // walking
            walk_left = ~direction;
            walk_right = direction;
            aaah = 0;
            digging = 0;
        end
        1: begin // falling
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        2: begin // digging
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
    endcase
end

endmodule