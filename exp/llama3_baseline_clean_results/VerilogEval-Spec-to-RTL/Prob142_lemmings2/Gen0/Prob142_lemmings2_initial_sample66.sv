module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state, next_state;

// Encode the states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;

// Sequential logic to store the current state and update it on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (bump_left) begin
                next_state <= WALK_RIGHT;
            end else begin
                next_state <= WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (bump_right) begin
                next_state <= WALK_LEFT;
            end else begin
                next_state <= WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                // Resume walking in the same direction as before the fall
                if (bump_left && bump_right) begin
                    // If bumped on both sides, switch directions
                    if (state == WALK_LEFT) begin
                        next_state <= WALK_RIGHT;
                    end else if (state == WALK_RIGHT) begin
                        next_state <= WALK_LEFT;
                    end else begin
                        next_state <= FALLING;
                    end
                end else if (bump_left) begin
                    next_state <= WALK_RIGHT;
                end else if (bump_right) begin
                    next_state <= WALK_LEFT;
                end else begin
                    // No bump, resume walking in the same direction as before the fall
                    if (state == WALK_LEFT) begin
                        next_state <= WALK_LEFT;
                    end else if (state == WALK_RIGHT) begin
                        next_state <= WALK_RIGHT;
                    end else begin
                        next_state <= FALLING;
                    end
                end
            end else begin
                next_state <= FALLING;
            end
        end
    endcase
end

// Determine the outputs based on the current state
always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end
        WALK_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
            aaah <= 1'b0;
        end
        FALLING: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
        end
    endcase
end

endmodule