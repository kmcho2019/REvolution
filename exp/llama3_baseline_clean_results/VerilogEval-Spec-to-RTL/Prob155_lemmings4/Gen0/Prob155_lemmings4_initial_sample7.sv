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

parameter WALK_LEFT = 3'b001;
parameter WALK_RIGHT = 3'b010;
parameter FALLING = 3'b011;
parameter DIGGING = 3'b100;
parameter SPLATTERED = 3'b000;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 5'b0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    state <= WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_right || bump_left) begin
                    state <= WALK_LEFT;
                end
            end
            FALLING: begin
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 5'b10100) begin
                        state <= SPLATTERED;
                    end else begin
                        if (state == WALK_LEFT) begin
                            state <= WALK_LEFT;
                        end else begin
                            state <= WALK_RIGHT;
                        end
                        fall_count <= 5'b0;
                    end
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                end
            end
            SPLATTERED: begin
                // Stay in this state forever
            end
        endcase
    end
end

always @(state) begin
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