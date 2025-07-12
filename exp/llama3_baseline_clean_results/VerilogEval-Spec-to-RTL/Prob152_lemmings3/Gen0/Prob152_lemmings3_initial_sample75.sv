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

// Define states
enum logic [1:0] {
    LEFT,
    RIGHT,
    FALLING,
    DIGGING
} state, next_state;

// Define current direction
logic [1:0] direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
        direction <= LEFT;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        LEFT: begin
            walk_left = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_left == 1'b1) begin
                next_state = RIGHT;
            end else if (bump_right == 1'b1) begin
                next_state = LEFT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            walk_right = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_left == 1'b1) begin
                next_state = LEFT;
            end else if (bump_right == 1'b1) begin
                next_state = RIGHT;
            end else begin
                next_state = RIGHT;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground == 1'b1) begin
                if (direction == LEFT) begin
                    next_state = LEFT;
                end else begin
                    next_state = RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if (state == LEFT || state == RIGHT) begin
        direction <= state;
    end
end

endmodule