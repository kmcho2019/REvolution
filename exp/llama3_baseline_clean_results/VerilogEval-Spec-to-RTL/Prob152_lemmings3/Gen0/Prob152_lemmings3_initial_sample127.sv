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

// State definition
enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state, next_state;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig && ground) begin
                next_state <= DIGGING;
            end else if (bump_left) begin
                next_state <= WALK_RIGHT;
            end else if (bump_right) begin
                next_state <= WALK_LEFT;
            end else begin
                next_state <= WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig && ground) begin
                next_state <= DIGGING;
            end else if (bump_right) begin
                next_state <= WALK_LEFT;
            end else if (bump_left) begin
                next_state <= WALK_RIGHT;
            end else begin
                next_state <= WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state <= (bump_left || bump_right)? (bump_left? WALK_RIGHT : WALK_LEFT) : (state == WALK_LEFT? WALK_LEFT : WALK_RIGHT);
            end else begin
                next_state <= FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state <= FALLING;
            end else begin
                next_state <= DIGGING;
            end
        end
        default: begin
            next_state <= WALK_LEFT;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        WALK_RIGHT: begin
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
        default: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
    endcase
end

endmodule