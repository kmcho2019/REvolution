module TopModule(
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    input         ground,
    output        walk_left,
    output        walk_right,
    output        aaah
);

reg [1:0] state; // 2'b00: walking left, 2'b01: walking right, 2'b10: falling
reg        direction; // 1: left, 0: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // walking left
        direction <= 1'b1; // left
    end else begin
        case (state)
            2'b00: begin // walking left
                if (!ground) begin
                    state <= 2'b10; // falling
                end else if (bump_left) begin
                    state <= 2'b01; // walking right
                    direction <= 1'b0; // right
                end else if (bump_right) begin
                    state <= 2'b00; // walking left
                end
            end
            2'b01: begin // walking right
                if (!ground) begin
                    state <= 2'b10; // falling
                end else if (bump_left) begin
                    state <= 2'b00; // walking left
                    direction <= 1'b1; // left
                end else if (bump_right) begin
                    state <= 2'b01; // walking right
                end
            end
            2'b10: begin // falling
                if (ground) begin
                    if (direction == 1'b1) begin
                        state <= 2'b00; // walking left
                    end else begin
                        state <= 2'b01; // walking right
                    end
                end
            end
            default: begin
                state <= 2'b00; // walking left
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule