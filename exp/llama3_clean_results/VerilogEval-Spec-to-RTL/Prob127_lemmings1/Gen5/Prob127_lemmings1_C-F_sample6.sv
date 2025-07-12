module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

// Enumerate states
typedef enum logic {LEFT, RIGHT} state_t;
state_t current_state, next_state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Define combinational logic
always_comb begin
    case (current_state)
        LEFT: begin
            if (bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = bump_right? LEFT : LEFT;
            end
        end
        RIGHT: begin
            if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = bump_left? RIGHT : RIGHT;
            end
        end
        default: begin
            next_state = LEFT;
        end
    endcase

    // Handle outputs
    case (current_state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    endcase
end

endmodule