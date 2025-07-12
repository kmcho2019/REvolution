module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    input           ground,
    output logic    walk_left,
    output logic    walk_right,
    output logic    aaah
);

// Enumerate states
enum logic [1:0] {
    Idle = 2'b00,
    WalkingLeft = 2'b01,
    WalkingRight = 2'b10,
    Falling = 2'b11
} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WalkingLeft;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;

    next_state = state;

    case (state)
        WalkingLeft: begin
            if (~ground) begin
                next_state = Falling;
            end else if (bump_left) begin
                next_state = WalkingRight;
            end
            walk_left = 1'b1;
        end
        WalkingRight: begin
            if (~ground) begin
                next_state = Falling;
            end else if (bump_right) begin
                next_state = WalkingLeft;
            end
            walk_right = 1'b1;
        end
        Falling: begin
            if (ground) begin
                // Resume previous direction
                if (bump_left || bump_right) begin
                    // If bumped in the same cycle ground reappears, change direction
                    if (state == WalkingLeft) begin
                        next_state = WalkingRight;
                    end else if (state == WalkingRight) begin
                        next_state = WalkingLeft;
                    end
                end else begin
                    // If not bumped, resume previous direction
                    if (state == WalkingLeft) begin
                        next_state = WalkingLeft;
                    end else if (state == WalkingRight) begin
                        next_state = WalkingRight;
                    end
                end
            end
            aaah = 1'b1;
        end
        default: begin
            next_state = WalkingLeft;
            walk_left = 1'b1;
        end
    endcase
end

endmodule