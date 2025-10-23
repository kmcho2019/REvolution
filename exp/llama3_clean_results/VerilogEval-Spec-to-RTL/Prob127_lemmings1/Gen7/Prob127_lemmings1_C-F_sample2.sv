module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Enumerate states
typedef enum logic [0:0] {LEFT, RIGHT} state_t;
state_t state, next_state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

// Define combinational logic
always_comb begin
    case (state)
        LEFT: begin
            next_state = bump_left ? RIGHT : LEFT;
        end
        RIGHT: begin
            next_state = bump_right ? LEFT : RIGHT;
        end
    endcase

    // Directly handle outputs based on current state
    case (state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

endmodule