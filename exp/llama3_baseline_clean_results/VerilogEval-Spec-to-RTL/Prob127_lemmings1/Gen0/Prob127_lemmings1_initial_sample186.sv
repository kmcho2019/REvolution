module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define states
enum {WALK_LEFT, WALK_RIGHT} state, next_state;

// Assign output based on state
assign walk_left = (state == WALK_LEFT)? 1'b1 : 1'b0;
assign walk_right = (state == WALK_RIGHT)? 1'b1 : 1'b0;

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
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
    endcase
    // Handle case when both bump_left and bump_right are 1
    if (bump_left && bump_right) begin
        case (state)
            WALK_LEFT: next_state = WALK_RIGHT;
            WALK_RIGHT: next_state = WALK_LEFT;
        endcase
    end
end

endmodule