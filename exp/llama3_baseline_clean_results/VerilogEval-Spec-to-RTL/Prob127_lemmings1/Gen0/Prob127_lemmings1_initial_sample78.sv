module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
enum logic [0:0] {WALK_LEFT, WALK_RIGHT} state, next_state;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Output logic
always_comb begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

// If both bump_left and bump_right are high, switch direction
always_comb begin
    if (bump_left && bump_right) begin
        if (state == WALK_LEFT) begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end else begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    end
end

endmodule