module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Enumerated type for the states
enum logic [0:0] {WALK_LEFT, WALK_RIGHT} state, next_state;

// Output logic for the current direction
logic walk_left_temp, walk_right_temp;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state <= WALK_RIGHT;
            end else begin
                next_state <= WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state <= WALK_LEFT;
            end else begin
                next_state <= WALK_RIGHT;
            end
        end
        default: begin
            next_state <= WALK_LEFT;
        end
    endcase

    // Output logic
    case (state)
        WALK_LEFT: begin
            walk_left_temp <= 1'b1;
            walk_right_temp <= 1'b0;
        end
        WALK_RIGHT: begin
            walk_left_temp <= 1'b0;
            walk_right_temp <= 1'b1;
        end
        default: begin
            walk_left_temp <= 1'b1;
            walk_right_temp <= 1'b0;
        end
    endcase
end

// Continuous assignment for output
assign walk_left = walk_left_temp;
assign walk_right = walk_right_temp;

endmodule