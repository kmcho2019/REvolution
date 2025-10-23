module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states
enum logic [0:0] {LEFT, RIGHT} state, next_state;

// Internal signals
logic internal_walk_left, internal_walk_right;

// Combinational logic for next state
always_comb begin
    case (state)
        LEFT: begin
            if (bump_left) next_state = RIGHT;
            else next_state = LEFT;
        end
        RIGHT: begin
            if (bump_right) next_state = LEFT;
            else next_state = RIGHT;
        end
        default: next_state = LEFT;
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= LEFT;
    else state <= next_state;
end

// Combinational logic for output
always_comb begin
    case (state)
        LEFT: begin
            internal_walk_left = 1'b1;
            internal_walk_right = 1'b0;
        end
        RIGHT: begin
            internal_walk_left = 1'b0;
            internal_walk_right = 1'b1;
        end
        default: begin
            internal_walk_left = 1'b1;
            internal_walk_right = 1'b0;
        end
    endcase
end

// Output logic
assign walk_left = internal_walk_left;
assign walk_right = internal_walk_right;

endmodule