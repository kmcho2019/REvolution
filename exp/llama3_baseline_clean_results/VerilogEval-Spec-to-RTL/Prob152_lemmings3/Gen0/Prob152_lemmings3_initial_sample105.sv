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

    reg [1:0] state, next_state;
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    reg direction;

    always @(*) begin
        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
                if (~ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
                if (~ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
                if (ground) begin
                    if (direction) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = FALLING;
                end
            end
            DIGGING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
                if (~ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            default: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
                next_state = WALK_LEFT;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 1;
        end else begin
            state <= next_state;
            if (state == WALK_LEFT) begin
                direction <= 1;
            end else if (state == WALK_RIGHT) begin
                direction <= 0;
            end else begin
                direction <= direction;
            end
        end
    end

endmodule