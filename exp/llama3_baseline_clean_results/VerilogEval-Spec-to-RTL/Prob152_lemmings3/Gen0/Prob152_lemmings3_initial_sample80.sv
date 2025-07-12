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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging
reg dir_before_fall; // store the direction before falling or digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
        dir_before_fall <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (!ground) begin
                    state <= 2; // fall
                    dir_before_fall <= 0;
                end else if (dig && ground) begin
                    state <= 3; // dig
                    dir_before_fall <= 0;
                end else if (bump_right) begin
                    state <= 1; // switch to walking right
                end
            end
            1: begin // walking right
                if (!ground) begin
                    state <= 2; // fall
                    dir_before_fall <= 1;
                end else if (dig && ground) begin
                    state <= 3; // dig
                    dir_before_fall <= 1;
                end else if (bump_left) begin
                    state <= 0; // switch to walking left
                end
            end
            2: begin // falling
                if (ground) begin
                    if (dir_before_fall) begin
                        state <= 1; // resume walking right
                    end else begin
                        state <= 0; // resume walking left
                    end
                end
            end
            3: begin // digging
                if (!ground) begin
                    state <= 2; // fall
                    dir_before_fall <= dir_before_fall;
                end
            end
            default: state <= 0;
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // walking left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // walking right
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        2: begin // falling
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3: begin // digging
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule