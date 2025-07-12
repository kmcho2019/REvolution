module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

enum logic [1:0] {
    FALLING = 2'b00,
    WALKING = 2'b01,
    DIGGING = 2'b10
} state;

enum logic {
    LEFT = 1'b0,
    RIGHT = 1'b1
} walk_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                    aaah <= 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= DIGGING;
                    digging <= 1'b1;
                    aaah <= 1'b0;
                end else if (bump_left) begin
                    walk_direction <= RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end else if (bump_right) begin
                    walk_direction <= LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            end
            FALLING: begin
                if (ground) begin
                    state <= WALKING;
                    aaah <= 1'b0;
                    if (walk_direction == LEFT) begin
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    digging <= 1'b0;
                    aaah <= 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                end
            end
        endcase
    end
end

endmodule