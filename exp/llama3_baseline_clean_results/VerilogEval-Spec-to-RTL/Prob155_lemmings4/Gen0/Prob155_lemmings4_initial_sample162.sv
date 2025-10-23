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

reg [2:0] state;
reg [4:0] fall_count;

localparam IDLE_LEFT = 3'b001;
localparam IDLE_RIGHT = 3'b010;
localparam FALLING = 3'b011;
localparam DIGGING = 3'b100;
localparam SPLATTERED = 3'b111;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_count <= 0;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= IDLE_RIGHT;
                end else if (bump_right) begin
                    state <= IDLE_LEFT;
                end
            end
            IDLE_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= IDLE_RIGHT;
                end else if (bump_right) begin
                    state <= IDLE_LEFT;
                end
            end
            FALLING: begin
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= SPLATTERED;
                    end else if (state == IDLE_LEFT) begin
                        state <= IDLE_LEFT;
                    end else if (state == IDLE_RIGHT) begin
                        state <= IDLE_RIGHT;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end
            end
            SPLATTERED: begin
                state <= SPLATTERED;
            end
            default: begin
                state <= IDLE_LEFT;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        IDLE_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        DIGGING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        SPLATTERED: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
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