module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

// Define the states
enum logic {LEFT, RIGHT} state, next_state;

// Combinational logic for next state
always_comb begin
    case (state)
        LEFT: begin
            if (bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = RIGHT;
            end
        end
        default: next_state = LEFT; // default to LEFT state
    endcase

    // Handle the case where both bump_left and bump_right are high
    if (bump_left && bump_right) begin
        next_state = (state == LEFT) ? RIGHT : LEFT;
    end
end

// Sequential logic for state register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
    end else begin
        state <= next_state;
    end
end

// Output logic
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule