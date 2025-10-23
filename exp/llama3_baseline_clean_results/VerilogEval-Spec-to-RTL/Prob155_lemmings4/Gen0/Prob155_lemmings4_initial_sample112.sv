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

parameter MAX_FALL_CYCLES = 20;

reg [2:0] state;
reg [5:0] fall_count;
reg prev_walk_dir;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b001;
        fall_count <= 6'b0;
        prev_walk_dir <= 1'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            3'b001: begin // walking left
                if (!ground) begin
                    state <= 3'b011;
                    fall_count <= 6'b1;
                    prev_walk_dir <= 1'b0;
                end else if (dig && ground) begin
                    state <= 3'b100;
                    prev_walk_dir <= 1'b0;
                end else if (bump_left) begin
                    state <= 3'b010;
                end
            end
            3'b010: begin // walking right
                if (!ground) begin
                    state <= 3'b011;
                    fall_count <= 6'b1;
                    prev_walk_dir <= 1'b1;
                end else if (dig && ground) begin
                    state <= 3'b100;
                    prev_walk_dir <= 1'b1;
                end else if (bump_right) begin
                    state <= 3'b001;
                end
            end
            3'b011: begin // falling
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > MAX_FALL_CYCLES) begin
                        state <= 3'b111;
                    end else if (prev_walk_dir) begin
                        state <= 3'b010;
                    end else begin
                        state <= 3'b001;
                    end
                    fall_count <= 6'b0;
                end
            end
            3'b100: begin // digging
                if (!ground) begin
                    state <= 3'b011;
                    fall_count <= 6'b1;
                end
            end
            3'b111: begin // splattered
                // do nothing
            end
            default: begin
                // do nothing
            end
        endcase
    end
end

always @(*) begin
    case (state)
        3'b001: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        3'b010: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        3'b011: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        3'b100: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        3'b111: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
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