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

reg [3:0] state;
reg [1:0] direction;
reg [4:0] fall_counter;

parameter WALKING_LEFT = 4'd0;
parameter WALKING_RIGHT = 4'd1;
parameter FALLING = 4'd2;
parameter DIGGING = 4'd3;
parameter SPLATTERED = 4'd4;

parameter LEFT = 2'd0;
parameter RIGHT = 2'd1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        direction <= LEFT;
        fall_counter <= 5'd0;
    end else begin
        case (state)
            WALKING_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    direction <= LEFT;
                    fall_counter <= 5'd1;
                end else if (dig) begin
                    state <= DIGGING;
                    direction <= LEFT;
                end else if (bump_left) begin
                    state <= WALKING_RIGHT;
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                end
            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    direction <= RIGHT;
                    fall_counter <= 5'd1;
                end else if (dig) begin
                    state <= DIGGING;
                    direction <= RIGHT;
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
                        if (direction == LEFT) begin
                            state <= WALKING_LEFT;
                        end else begin
                            state <= WALKING_RIGHT;
                        end
                    end
                    fall_counter <= 5'd0;
                end else begin
                    fall_counter <= fall_counter + 5'd1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 5'd1;
                end
            end
            SPLATTERED: begin
                // do nothing
            end
        endcase
    end
end

always @(*) begin
    case (state)
        WALKING_LEFT: begin
            walk_left = 1'd1;
            walk_right = 1'd0;
            aaah = 1'd0;
            digging = 1'd0;
        end
        WALKING_RIGHT: begin
            walk_left = 1'd0;
            walk_right = 1'd1;
            aaah = 1'd0;
            digging = 1'd0;
        end
        FALLING: begin
            walk_left = 1'd0;
            walk_right = 1'd0;
            aaah = 1'd1;
            digging = 1'd0;
        end
        DIGGING: begin
            walk_left = 1'd0;
            walk_right = 1'd0;
            aaah = 1'd0;
            digging = 1'd1;
        end
        SPLATTERED: begin
            walk_left = 1'd0;
            walk_right = 1'd0;
            aaah = 1'd0;
            digging = 1'd0;
        end
    endcase
end

endmodule