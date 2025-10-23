module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [2:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTERED
reg [5:0] fall_count; // counter for falling

parameter WALK_LEFT = 3'b000;
parameter WALK_RIGHT = 3'b001;
parameter FALLING = 3'b010;
parameter DIGGING = 3'b011;
parameter SPLATTERED = 3'b100;

always @(posedge clk or posedge areset) begin
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
                end else if (bump_left) begin
                    state <= WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                end
            end
            FALLING: begin
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= SPLATTERED;
                    end else begin
                        if (state == WALK_LEFT) begin
                            state <= WALK_LEFT;
                        end else begin
                            state <= WALK_RIGHT;
                        end
                    end
                    fall_count <= 0;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (!dig) begin
                    if (state == DIGGING) begin
                        if (fall_count == 0) begin
                            state <= WALK_LEFT;
                        end else begin
                            state <= WALK_RIGHT;
                        end
                    end
                end
            end
            SPLATTERED: begin
                // do nothing
            end
        endcase
    end
end

always @(state) begin
    case (state)
        WALK_LEFT: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        WALK_RIGHT: begin
            walk_left <= 0;
            walk_right <= 1;
            aaah <= 0;
            digging <= 0;
        end
        FALLING: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
            digging <= 0;
        end
        DIGGING: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end
        SPLATTERED: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
    endcase
end

endmodule