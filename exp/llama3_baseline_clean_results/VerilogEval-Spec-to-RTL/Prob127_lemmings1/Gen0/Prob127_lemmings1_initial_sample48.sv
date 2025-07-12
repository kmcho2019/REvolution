module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
enum logic [1:0] {WALK_LEFT, WALK_RIGHT} state, next_state;

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

// Next state logic
always_comb begin
    case (state)
        WALK_LEFT: begin
            if (bump_left == 1'b1) begin
                next_state = WALK_RIGHT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule