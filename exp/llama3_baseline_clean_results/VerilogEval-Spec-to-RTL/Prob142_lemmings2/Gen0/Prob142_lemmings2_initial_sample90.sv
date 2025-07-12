module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg prev_walk_dir;  // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;  // Reset
        prev_walk_dir <= 0;
    end else begin
        case (state)
            2'b00: begin  // Reset
                state <= 2'b01;  // WalkingLeft
            end
            2'b01: begin  // WalkingLeft
                if (bump_left) begin
                    state <= 2'b10;  // WalkingRight
                    prev_walk_dir <= 1;
                end else if (!ground) begin
                    state <= 2'b11;  // Falling
                end
            end
            2'b10: begin  // WalkingRight
                if (bump_right) begin
                    state <= 2'b01;  // WalkingLeft
                    prev_walk_dir <= 0;
                end else if (!ground) begin
                    state <= 2'b11;  // Falling
                end
            end
            2'b11: begin  // Falling
                if (ground) begin
                    if (prev_walk_dir == 0) begin
                        state <= 2'b01;  // WalkingLeft
                    end else begin
                        state <= 2'b10;  // WalkingRight
                    end
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin  // Reset
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
        end
        2'b01: begin  // WalkingLeft
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        2'b10: begin  // WalkingRight
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        2'b11: begin  // Falling
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
    endcase
end

endmodule