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

enum logic [2:0] {
    WALKING_LEFT = 3'd0,
    WALKING_RIGHT = 3'd1,
    FALLING = 3'd2,
    DIGGING = 3'd3,
    SPLATTERED = 3'd4
} state, next_state;

reg [4:0] fall_counter;
reg splattered;

FallCounter fall_counter_module (
   .clk(clk),
   .areset(areset),
   .ground(ground),
   .falling(state == FALLING),
   .fall_counter(fall_counter),
   .splattered(splattered)
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            WALKING_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALKING_RIGHT;
                end else if (bump_right) begin
                    state <= WALKING_LEFT;
                end
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALKING_LEFT;
                end else if (bump_right) begin
                    state <= WALKING_RIGHT;
                end
                walk_left <= 0;
                walk_right <= 1;
                aaah <= 0;
                digging <= 0;
            end
            FALLING: begin
                if (ground) begin
                    if (splattered) begin
                        state <= SPLATTERED;
                    end else begin
                        if (state == WALKING_LEFT) begin
                            state <= WALKING_LEFT;
                        end else begin
                            state <= WALKING_RIGHT;
                        end
                    end
                end
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
                digging <= 0;
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 1;
            end
            SPLATTERED: begin
                state <= SPLATTERED;
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule

module FallCounter (
    input clk,
    input areset,
    input ground,
    input falling,
    output reg [4:0] fall_counter,
    output reg splattered
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        fall_counter <= 5'd0;
        splattered <= 1'b0;
    end else begin
        if (falling) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 5'd0;
        end
        if (ground && fall_counter > 5'd20) begin
            splattered <= 1'b1;
        end else begin
            splattered <= 1'b0;
        end
    end
end

endmodule