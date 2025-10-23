module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states as an enum
enum logic [0:0] {WALK_LEFT, WALK_RIGHT} state, next_state;

// Output logic
logic walk_left_int, walk_right_int;

// Combinational logic to determine the next state
always_comb begin
    case(state)
        WALK_LEFT: begin
            if (bump_left) next_state = WALK_RIGHT;
            else next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (bump_right) next_state = WALK_LEFT;
            else next_state = WALK_RIGHT;
        end
    endcase

    if (bump_left && bump_right) begin
        case(state)
            WALK_LEFT: next_state = WALK_RIGHT;
            WALK_RIGHT: next_state = WALK_LEFT;
        endcase
    end

    // Determine the output based on the current state
    case(state)
        WALK_LEFT: begin
            walk_left_int = 1'b1;
            walk_right_int = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left_int = 1'b0;
            walk_right_int = 1'b1;
        end
    endcase
end

// Sequential logic to update the state
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= WALK_LEFT;
    else state <= next_state;
end

// Assign the internal output to the actual output
assign walk_left = walk_left_int;
assign walk_right = walk_right_int;

endmodule