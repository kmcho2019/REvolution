module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    input           ground,
    input           dig,
    output          walk_left,
    output          walk_right,
    output          aaah,
    output          digging
);

reg [1:0] state; // 0: walking_left, 1: walking_right, 2: falling, 3: digging
reg          prev_walk_left; // previous walking direction
reg          prev_walk_right; // previous walking direction

localparam WALKING_LEFT = 2'b00;
localparam WALKING_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        prev_walk_left <= 1'b1;
        prev_walk_right <= 1'b0;
    end else begin
        case (state)
            WALKING_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALKING_RIGHT;
                    prev_walk_left <= 1'b0;
                    prev_walk_right <= 1'b1;
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                end
            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                    prev_walk_left <= 1'b1;
                    prev_walk_right <= 1'b0;
                end else if (bump_left) begin
                    state <= WALKING_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (prev_walk_left) begin
                        state <= WALKING_LEFT;
                    end else begin
                        state <= WALKING_RIGHT;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end
            end
            default: state <= WALKING_LEFT;
        endcase
    end
end

always @(*) begin
    case (state)
        WALKING_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALKING_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
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