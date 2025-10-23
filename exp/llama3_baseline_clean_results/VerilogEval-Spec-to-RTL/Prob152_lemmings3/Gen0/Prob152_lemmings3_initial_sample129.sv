module TopModule(
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

    // Define states
    typedef enum logic [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10,
        DIGGING = 2'b11
    } state_type;

    state_type state, next_state;
    reg [1:0] prev_dir;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_dir <= 2'b00;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            WALK_LEFT: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
                if (bump_left) begin
                    next_state = WALK_RIGHT;
                    prev_dir = 2'b01;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
                digging = 1'b0;
                if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                    prev_dir = 2'b00;
                end else if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
                if (ground) begin
                    if (prev_dir == 2'b00) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = FALLING;
                end
            end
            DIGGING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
                if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

endmodule