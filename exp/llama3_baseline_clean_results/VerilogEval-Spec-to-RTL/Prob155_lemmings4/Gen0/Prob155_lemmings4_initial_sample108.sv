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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging, 4: splattered
reg [4:0] fall_count; // counter for the number of clock cycles the Lemming has been falling
reg walk_dir; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // initial state: walking left
        walk_dir <= 0; // initial direction: left
        fall_count <= 0;
    end else begin
        case (state)
            0, 1: begin // walking
                if (~ground) begin
                    state <= 2; // fall
                    fall_count <= 1;
                end else if (dig && (state == 0 && ~bump_left && ~bump_right)) begin
                    state <= 3; // dig
                end else if (bump_left && bump_right) begin
                    walk_dir <= ~walk_dir; // switch direction
                end else if (bump_left && (state == 0 || (state == 1 && ~bump_right))) begin
                    walk_dir <= 1; // switch to right
                end else if (bump_right && (state == 1 || (state == 0 && ~bump_left))) begin
                    walk_dir <= 0; // switch to left
                end
            end
            2: begin // falling
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4; // splattered
                    end else begin
                        state <= walk_dir ? 1 : 0; // resume walking
                    end
                end
            end
            3: begin // digging
                if (~ground) begin
                    state <= 2; // fall
                    fall_count <= 1;
                end
            end
            4: begin // splattered
                // do nothing
            end
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
        4: begin // splattered
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule