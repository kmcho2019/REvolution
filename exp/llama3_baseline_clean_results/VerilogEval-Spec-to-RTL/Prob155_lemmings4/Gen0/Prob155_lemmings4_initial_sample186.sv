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

reg [4:0] state; // 5 states: WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, SPLATTERED
reg [5:0] fall_count; // counter for number of clock cycles falling

localparam WALK_LEFT = 0;
localparam WALK_RIGHT = 1;
localparam FALLING = 2;
localparam DIGGING = 3;
localparam SPLATTERED = 4;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    if (bump_left) begin
                        state <= WALK_RIGHT;
                    end else if (bump_right) begin
                        state <= WALK_LEFT;
                    end
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    if (bump_left) begin
                        state <= WALK_LEFT;
                    end else if (bump_right) begin
                        state <= WALK_LEFT;
                    end
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= SPLATTERED;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else begin
                        state <= WALK_LEFT;
                    end
                end else begin
                    fall_count <= fall_count + 1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end
            end
            SPLATTERED: begin
                // do nothing
            end
        endcase
    end
end

always @ (state) begin
    case (state)
        WALK_LEFT: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        WALK_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        FALLING: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
        end
        DIGGING: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
        end
        SPLATTERED: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
    endcase
end

endmodule