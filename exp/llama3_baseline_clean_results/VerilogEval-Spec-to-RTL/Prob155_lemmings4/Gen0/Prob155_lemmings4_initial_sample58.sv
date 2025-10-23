module TopModule (
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

// State definitions
typedef enum logic [2:0] {
    WALK_LEFT = 3'b000,
    WALK_RIGHT = 3'b001,
    FALLING = 3'b010,
    DIGGING = 3'b011,
    SPLATTERED = 3'b100
} state_t;

// State register
state_t state, next_state;

// Counter to keep track of falling time
reg [5:0] fall_count;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_count <= fall_count + 1;
        end else begin
            fall_count <= 0;
        end
    end
end

always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (ground == 0) begin
                next_state = FALLING;
            end else if (dig == 1) begin
                next_state = DIGGING;
            end else if (bump_right == 1 || (bump_left == 0 && bump_right == 0 && bump_left == 1)) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (ground == 0) begin
                next_state = FALLING;
            end else if (dig == 1) begin
                next_state = DIGGING;
            end else if (bump_left == 1 || (bump_left == 1 && bump_right == 1)) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground == 1 && fall_count > 20) begin
                next_state = SPLATTERED;
            end else if (ground == 1) begin
                if (dig == 1) begin
                    next_state = DIGGING;
                end else if (bump_left == 1 || bump_right == 1) begin
                    next_state = WALK_LEFT;
                end else if (bump_left == 0 && bump_right == 0) begin
                    if (fall_count == 0) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = WALK_LEFT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            digging = 1;
            if (ground == 0) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

endmodule