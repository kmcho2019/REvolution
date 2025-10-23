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

reg [2:0] state;
reg [5:0] fall_counter;

parameter WALK_LEFT = 3'b001;
parameter WALK_RIGHT = 3'b010;
parameter FALLING = 3'b011;
parameter DIGGING = 3'b100;
parameter SPLATTERED = 3'b000;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
    end else begin
        case (state)
            WALK_LEFT: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALK_RIGHT;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                digging <= 1'b0;
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALK_LEFT;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                end
            end
            FALLING: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= SPLATTERED;
                    end else if (state == FALLING && (bump_left || bump_right)) begin
                        if (bump_left && bump_right) begin
                            if (state == WALK_LEFT) begin
                                state <= WALK_RIGHT;
                            end else begin
                                state <= WALK_LEFT;
                            end
                        end else if (bump_left) begin
                            state <= WALK_RIGHT;
                        end else begin
                            state <= WALK_LEFT;
                        end
                    end else begin
                        state <= WALK_LEFT;
                    end
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            DIGGING: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b1;
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                end
            end
            SPLATTERED: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule