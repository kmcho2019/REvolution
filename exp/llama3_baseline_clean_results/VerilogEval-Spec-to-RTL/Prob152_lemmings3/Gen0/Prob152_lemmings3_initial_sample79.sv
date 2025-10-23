module TopModule (
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

// Define the states
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALL,
    DIG_LEFT,
    DIG_RIGHT
} state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Sequential logic
always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    
    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (dig && ground) begin
                next_state = DIG_LEFT;
            end else if (~ground) begin
                next_state = FALL;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (dig && ground) begin
                next_state = DIG_RIGHT;
            end else if (~ground) begin
                next_state = FALL;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALL: begin
            aaah = 1;
            if (ground) begin
                if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end else begin
                next_state = FALL;
            end
        end
        DIG_LEFT: begin
            walk_left = 1;
            digging = 1;
            if (~ground) begin
                next_state = FALL;
            end else begin
                next_state = DIG_LEFT;
            end
        end
        DIG_RIGHT: begin
            walk_right = 1;
            digging = 1;
            if (~ground) begin
                next_state = FALL;
            end else begin
                next_state = DIG_RIGHT;
            end
        end
    endcase
end

endmodule