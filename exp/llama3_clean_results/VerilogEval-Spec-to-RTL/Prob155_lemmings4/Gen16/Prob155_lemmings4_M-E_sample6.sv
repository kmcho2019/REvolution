module TopModule(
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

enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

enum logic [0:0] {
    LEFT,
    RIGHT
} direction, next_direction;

reg [4:0] fall_counter;
reg [4:0] next_fall_counter;

always_comb begin
    next_state = state;
    next_direction = direction;
    next_fall_counter = fall_counter;

    case (state)
        WALKING: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 5'd1;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left && ~bump_right) begin
                next_direction = RIGHT;
            end else if (~bump_left && bump_right) begin
                next_direction = LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                end
                next_fall_counter = 5'd0;
            end else begin
                next_fall_counter = fall_counter + 5'd1;
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 5'd1;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        direction <= LEFT;
        fall_counter <= 5'd0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        direction <= next_direction;
        fall_counter <= next_fall_counter;

        case (state)
            WALKING: begin
                walk_left <= (direction == LEFT);
                walk_right <= (direction == RIGHT);
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
end

endmodule