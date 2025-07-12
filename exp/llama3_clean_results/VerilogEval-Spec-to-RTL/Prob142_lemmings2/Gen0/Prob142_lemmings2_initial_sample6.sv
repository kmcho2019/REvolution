// Define the states as an enum
enum logic [1:0] {LEFT, RIGHT, FALLING} state, next_state;

module TopModule(
    input  logic clk,
    input  logic areset,
    input  logic bump_left,
    input  logic bump_right,
    input  logic ground,
    output logic walk_left,
    output logic walk_right,
    output logic aaah
);

// Sequential logic: update the current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic: determine the next state and outputs
always_comb begin
    // Default values
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;

    case (state)
        LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = RIGHT;
            end
            walk_left = 1'b1;
        end
        RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_right) begin
                next_state = LEFT;
            end
            walk_right = 1'b1;
        end
        FALLING: begin
            if (ground) begin
                // If falling and ground appears, resume previous direction
                if (bump_left || bump_right) begin
                    // Ignore bump signals when transitioning from falling to walking
                    if (state == FALLING) begin
                        if (bump_left) next_state = RIGHT;
                        else if (bump_right) next_state = LEFT;
                    end
                end else begin
                    // Resume previous direction
                    if (state == FALLING) begin
                        if (bump_left) next_state = RIGHT;
                        else if (bump_right) next_state = LEFT;
                        else if (next_state == FALLING) next_state = LEFT; // default to LEFT
                    end
                end
            end
            aaah = 1'b1;
        end
        default: begin
            next_state = LEFT;
        end
    endcase
end

endmodule