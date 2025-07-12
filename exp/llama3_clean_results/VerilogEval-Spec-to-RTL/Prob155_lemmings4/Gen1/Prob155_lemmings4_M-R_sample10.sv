module TopModule (
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

reg [1:0] state;
reg [4:0] fall_counter;

localparam WALKING_LEFT = 2'd0;
localparam WALKING_RIGHT = 2'd1;
localparam FALLING = 2'd2;
localparam DIGGING = 2'd3;
localparam SPLATTERED = 2'd4;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        fall_counter <= 5'd0;
    end else begin
        case (state)
            WALKING_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALKING_RIGHT;
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                end
            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALKING_LEFT;
                end else if (bump_right) begin
                    state <= WALKING_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        if (state == WALKING_LEFT) begin
                            state <= WALKING_LEFT;
                        end else begin
                            state <= WALKING_RIGHT;
                        end
                    end
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                end
            end
            SPLATTERED: begin
                state <= SPLATTERED;
            end
        endcase
    end
end

always @(posedge clk) begin
    case (state)
        WALKING_LEFT: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        WALKING_RIGHT: begin
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