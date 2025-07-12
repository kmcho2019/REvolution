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

// Enumerate the states
enum logic [1:0] {
    WALK_LEFT = 2'b00,
    WALK_RIGHT = 2'b01,
    FALLING = 2'b10,
    DIGGING = 2'b11
} state, next_state;

// Default output values
assign walk_left = 1'b0;
assign walk_right = 1'b0;
assign aaah = 1'b0;
assign digging = 1'b0;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (state)
        WALK_LEFT: begin
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
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
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
            walk_right = 1'b1;
        end
        FALLING: begin
            if (ground) begin
                // Determine the previous walking state
                if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else if (state == WALK_RIGHT) begin
                    next_state = WALK_RIGHT;
                end else if (state == DIGGING) begin
                    if (state == DIGGING) begin
                        if (bump_left) begin
                            next_state = WALK_RIGHT;
                        end else begin
                            next_state = WALK_LEFT;
                        end
                    end
                end else begin
                    next_state = WALK_LEFT;
                end
            end else begin
                next_state = FALLING;
            end
            aaah = 1'b1;
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
            digging = 1'b1;
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

endmodule